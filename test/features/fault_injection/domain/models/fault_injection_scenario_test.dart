import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/features/fault_injection/domain/models/fault_injection_scenario.dart';

void main() {
  group('FaultScenarioModel and ExecutionStepLog Tests', () {
    test('ExecutionStepLog instantiates with correct defaults and values', () {
      final now = DateTime.now();
      final log = ExecutionStepLog(
        timestamp: now,
        message: 'Step initialized',
        isError: false,
        isSuccess: true,
        elapsedMs: 45,
      );

      expect(log.timestamp, now);
      expect(log.message, 'Step initialized');
      expect(log.isError, isFalse);
      expect(log.isSuccess, isTrue);
      expect(log.elapsedMs, 45);
    });

    test('FaultScenarioModel defaults and copyWith behavior', () {
      const model = FaultScenarioModel(
        type: FaultScenarioType.concurrent401,
        category: FaultCategory.network,
        titleKey: 'concurrent_401_title',
        descKey: 'concurrent_401_desc',
      );

      expect(model.status, ScenarioStatus.idle);
      expect(model.steps, isEmpty);
      expect(model.traceId, isNull);
      expect(model.lastExecutionDurationMs, isNull);

      final updated = model.copyWith(
        status: ScenarioStatus.running,
        traceId: 'trace-12345',
        lastExecutionDurationMs: 120,
        steps: [
          ExecutionStepLog(
            timestamp: DateTime.now(),
            message: 'Dispatching concurrent requests',
          ),
        ],
      );

      expect(updated.status, ScenarioStatus.running);
      expect(updated.traceId, 'trace-12345');
      expect(updated.lastExecutionDurationMs, 120);
      expect(updated.steps.length, 1);
      expect(updated.type, FaultScenarioType.concurrent401);
      expect(updated.category, FaultCategory.network);
    });

    test('FaultCategory and FaultScenarioType enum integrity', () {
      expect(FaultCategory.values.length, 4);
      expect(FaultScenarioType.values.length, 7);
      expect(ScenarioStatus.values.length, 5);
    });
  });
}
