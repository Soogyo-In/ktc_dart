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
    expect(iterable.count((element) => element.isEven), 2);
  });

  group('Distinct', () {
    test('distinct', () {
      final distinct = [...iterable, ...iterable].distinct;

      expect(distinct, [0, 1, 2]);
    });

    test('distinctBy', () {
      final distinctBy = iterable.distinctBy((element) => element.isEven);

      expect(distinctBy, [0, 1]);
    });
  });

  group('ElementAt', () {
    test('ElementAtOrElse', () {
      expect(iterable.elementAtOrElse(0, (index) => -index), 0);
      expect(iterable.elementAtOrElse(2, (index) => -index), 2);
      expect(iterable.elementAtOrElse(-1, (index) => -index), 1);
      expect(iterable.elementAtOrElse(3, (index) => -index), -3);
    });

    test('ElementAtOrNull', () {
      expect(iterable.elementAtOrNull(0), 0);
      expect(iterable.elementAtOrNull(2), 2);
      expect(iterable.elementAtOrNull(-1), null);
      expect(iterable.elementAtOrNull(3), null);
    });
  });

  group('Where', () {
    test('whereIndexed', () {
      final whereIndexed = iterable.whereIndexed(
        (index, element) => (index + element).isEven,
      );

      expect(whereIndexed, [0, 1, 2]);
    });

    test('whereIsInstance', () {
      final whereIsInstance = [0, '1', 2].whereIsInstance<String>();

      expect(whereIsInstance, ['1']);
    });

    test('whereNot', () {
      final whereNot = iterable.whereNot((element) => element.isEven);

      expect(whereNot, [1]);
    });

    test('whereNotNull', () {
      final whereNotNull = [null, 1, null, 3].whereNotNull();

      expect(whereNotNull, [1, 3]);
    });
  });

  group('Find', () {
    test('find', () {
      expect(iterable.find((element) => element.isEven), 0);
      expect(iterable.find((element) => element.isNegative), null);
    });

    test('findLast', () {
      expect(iterable.findLast((element) => element.isEven), 2);
      expect(iterable.findLast((element) => element.isNegative), null);
    });
  });
}
