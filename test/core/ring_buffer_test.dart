import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';

void main() {
  group('RingBuffer Tests', () {
    test('Should initialize with correct capacity and empty state', () {
      final buffer = RingBuffer<int>(3);
      expect(buffer.capacity, equals(3));
      expect(buffer.length, equals(0));
      expect(buffer.isEmpty, isTrue);
      expect(buffer.isFull, isFalse);
    });

    test('Should insert elements without exceeding capacity', () {
      final buffer = RingBuffer<int>(3);
      buffer.add(10);
      buffer.add(20);

      expect(buffer.length, equals(2));
      expect(buffer.isEmpty, isFalse);
      expect(buffer.isFull, isFalse);
      expect(buffer[0], equals(10));
      expect(buffer[1], equals(20));
    });

    test('Should overwrite oldest elements when full', () {
      final buffer = RingBuffer<int>(3);
      buffer.add(10);
      buffer.add(20);
      buffer.add(30);

      expect(buffer.isFull, isTrue);
      expect(buffer.length, equals(3));

      // Overwrite oldest (10)
      buffer.add(40);
      expect(buffer.length, equals(3));
      expect(buffer[0], equals(20)); // 10 is replaced, 20 is now oldest
      expect(buffer[1], equals(30));
      expect(buffer[2], equals(40)); // 40 is newest

      // Overwrite next oldest (20)
      buffer.add(50);
      expect(buffer[0], equals(30));
      expect(buffer[1], equals(40));
      expect(buffer[2], equals(50));
    });

    test('Should throw RangeError on invalid index access', () {
      final buffer = RingBuffer<int>(3);
      buffer.add(10);

      expect(() => buffer[-1], throwsRangeError);
      expect(() => buffer[1], throwsRangeError);
      expect(() => buffer[3], throwsRangeError);
    });

    test('Should clear items and reset state', () {
      final buffer = RingBuffer<int>(3);
      buffer.add(1);
      buffer.add(2);
      buffer.clear();

      expect(buffer.length, equals(0));
      expect(buffer.isEmpty, isTrue);
      expect(() => buffer[0], throwsRangeError);
    });

    test('Should generate list representation correctly', () {
      final buffer = RingBuffer<int>(3);
      buffer.add(10);
      buffer.add(20);
      buffer.add(30);
      buffer.add(40); // Overwrites 10

      final list = buffer.toList();
      expect(list, equals([20, 30, 40]));
    });
  });
}
