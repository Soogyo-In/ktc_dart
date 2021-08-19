import 'package:test/scaffolding.dart';
import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  final empty = <int>[];
  late List<int> list;

  setUp(() {
    list = [0, 1, 2];
  });

  group('Operator', () {
    test('-', () {
      expect(empty - [0], []);
      expect([0] - [], [0]);
      expect([0] - [0], []);
      expect([0] - [0, 1], []);
      expect([0, 1] - [0], [1]);
      expect([0, 1] - [0, 2], [1]);
      expect([0, 1] - [2, 3], [0, 1]);
      expect([0, 0, 2] - [0], [2]);
      expect([0, 0, 2] - [0, 2], []);
    });

    test('+', () {
      expect(empty + [0], [0]);
      expect([0] + [], [0]);
      expect([0] + [1], [0, 1]);
      expect([1] + [0], [1, 0]);
      expect([0] + [0, 1], [0, 0, 1]);
      expect([0, 1] + [0], [0, 1, 0]);
      expect([0, 1] + [2, 3], [0, 1, 2, 3]);
    });

    test('<<', () {
      expect(empty << 1, []);
      expect(() => list << -1, throwsA(isArgumentError));
      expect(list << 0, [0, 1, 2]);
      expect(list << 1, [1, 2]);
      expect(list << 2, [2]);
      expect(list << 3, []);
      expect(list << 4, []);
    });

    test('>>', () {
      expect(empty >> 1, []);
      expect(() => list >> -1, throwsA(isArgumentError));
      expect(list >> 0, [0, 1, 2]);
      expect(list >> 1, [0, 1]);
      expect(list >> 2, [0]);
      expect(list >> 3, []);
      expect(list >> 4, []);
    });

    test('^', () {
      expect(empty ^ [], []);
      expect([0] ^ [], [0]);
      expect([0] ^ [1], [0, 1]);
      expect([0, 0] ^ [1], [0, 1]);
      expect([0, 0] ^ [1, 1], [0, 1]);
      expect([0, 0, 2] ^ [2, 2, 3], [0, 3]);
    });
  });
}
