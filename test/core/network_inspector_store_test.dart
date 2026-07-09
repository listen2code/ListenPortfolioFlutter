import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';

void main() {
  group('NetworkInspectorStore Tests', () {
    late NetworkInspectorStore store;

    setUp(() {
      store = NetworkInspectorStore.instance;
      store.clear();
    });

    tearDown(() {
      store.clear();
    });

    test('should add requests and respect max entries limit (FIFO)', () {
      expect(store.requestsNotifier.value.isEmpty, isTrue);

      // Add maxEntries + 10 requests
      const int addCount = NetworkInspectorStore.maxEntries + 10;
      for (int i = 0; i < addCount; i++) {
        final entry = NetworkRequestEntry(
          id: 'req_$i',
          traceId: 'trace_$i',
          method: 'GET',
          url: 'https://example.com/api/$i',
          path: '/api/$i',
          headers: const {},
          requestTime: DateTime.now(),
        );
        store.addRequest(entry);
      }

      final list = store.requestsNotifier.value;
      expect(list.length, equals(NetworkInspectorStore.maxEntries));
      // Oldest 10 requests (req_0 to req_9) should be discarded
      expect(list.first.id, equals('req_10'));
      expect(list.last.id, equals('req_${addCount - 1}'));
    });

    test('should update request details correctly', () {
      final entry = NetworkRequestEntry(
        id: 'req_target',
        traceId: 'trace_target',
        method: 'POST',
        url: 'https://example.com/api/target',
        path: '/api/target',
        headers: const {},
        requestBody: 'hello',
        requestTime: DateTime.now(),
      );

      store.addRequest(entry);
      expect(store.requestsNotifier.value.first.statusCode, isNull);

      final now = DateTime.now();
      store.updateRequest('req_target', (e) {
        return e.copyWith(
          statusCode: 200,
          responseBody: 'world',
          responseTime: now,
          durationMs: 150,
        );
      });

      final updated = store.requestsNotifier.value.first;
      expect(updated.statusCode, equals(200));
      expect(updated.responseBody, equals('world'));
      expect(updated.responseTime, equals(now));
      expect(updated.durationMs, equals(150));
    });

    test('should do nothing when trying to update non-existent request', () {
      final entry = NetworkRequestEntry(
        id: 'req_1',
        traceId: 'trace_1',
        method: 'GET',
        url: 'https://example.com',
        path: '/',
        headers: const {},
        requestTime: DateTime.now(),
      );
      store.addRequest(entry);

      store.updateRequest('non_existent', (e) => e.copyWith(statusCode: 400));

      expect(store.requestsNotifier.value.first.statusCode, isNull);
    });

    test('should clear all requests', () {
      store.addRequest(NetworkRequestEntry(
        id: 'req_1',
        traceId: 'trace_1',
        method: 'GET',
        url: 'https://example.com',
        path: '/',
        headers: const {},
        requestTime: DateTime.now(),
      ));

      expect(store.requestsNotifier.value.isNotEmpty, isTrue);

      store.clear();

      expect(store.requestsNotifier.value.isEmpty, isTrue);
    });
  });
}
