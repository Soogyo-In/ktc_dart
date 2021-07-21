import 'package:test/scaffolding.dart';
import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  late Iterable<int> iterable;

  setUp(() {
    iterable = Iterable.generate(3);
  });

  group('Numeric iterable', () {
    test('average', () {
      expect([1, 2].average, 1.5);
      expect([1.0, 2.0].average, 1.5);
      expect([double.nan, double.nan].average, isNaN);
      expect([double.nan, 1.1].average, isNaN);
      expect([double.nan, 1].average, isNaN);
      expect([1, 2.0].average, 1.5);
      expect([0, 0].average, 0.0);

      expect([1, -2].average, -0.5);
      expect([1.0, -2.0].average, -0.5);
      expect([double.nan, -double.nan].average, isNaN);
      expect([double.nan, -1.1].average, isNaN);
      expect([double.nan, -1].average, isNaN);
      expect([1, -2.0].average, -0.5);
      expect([0, -0].average, 0.0);
    });
  });

  group('Associate', () {
    test('associate', () {
      final associated = iterable.associate((element) => MapEntry(
            element.toString(),
            element * 2,
          ));

      expect(associated, {'0': 0, '1': 2, '2': 4});
    });

    test('associateBy', () {
      final associated = iterable.associateBy((element) => element.toString());

      expect(associated, {'0': 0, '1': 1, '2': 2});
    });

    test('associateAndTransformBy', () {
      final associated = iterable.associateAndTransformBy(
        (element) => element.toString(),
        (element) => element * 2,
      );

      expect(associated, {'0': 0, '1': 2, '2': 4});
    });

    test('associaateWith', () {
      final associated = iterable.associateWith(
        (element) => element.toString(),
      );

      expect(associated, {0: '0', 1: '1', 2: '2'});
    });

    group('Chunked', () {
      test('chunked', () {
        final chunked = iterable.chunked(2);

        expect(chunked, [
          [0, 1],
          [2],
        ]);
      });

      test('chunkedAndTransform', () {
        final chunked = iterable.chunkedAndTransform(
          2,
          (chunk) => chunk.reduce((value, element) => value + element),
        );

        expect(chunked, [1, 2]);
      });
    });
  });

  test('count', () {
    expect(iterable.count(), 3);
    expect(iterable.count((element) => element % 2 == 0), 2);
  });

  group('Distinct', () {
    test('distinct', () {
      expect([...iterable, ...iterable].distinct, [0, 1, 2]);
    });

    test('distinctBy', () {
      expect(
        iterable.distinctBy((element) => element % 2 == 0),
        [0, 1],
      );
    });
  });
}
