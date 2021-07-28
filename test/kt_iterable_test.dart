import 'package:test/scaffolding.dart';
import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  late Iterable<int> iterable;

  setUp(() {
    iterable = Iterable.generate(3);
  });

  group('NumIterable', () {
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

  group('DeepIterable', () {
    test('flatten', () {
      expect(
        [
          [1, 2],
          [3, 4]
        ].flatten,
        [1, 2, 3, 4],
      );

      expect(
        [
          [1, 2],
          [
            3,
            4,
            [5, 6]
          ]
        ].flatten,
        [
          1,
          2,
          3,
          4,
          [5, 6]
        ],
      );
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

  test('expandIndexed', () {
    final expandIndexed =
        iterable.expandIndexed((index, element) => [index, element]);

    expect(expandIndexed, [0, 0, 1, 1, 2, 2]);
  });

  group('First', () {
    test('firstNotNullOf', () {
      expect(iterable.firstNotNullOf((element) => element.toString()), '0');
      expect(
        () => iterable.firstNotNullOf((element) => null),
        throwsA(isA<NoSuchElementException>()),
      );
    });

    test('firstNotNullOfOrNull', () {
      expect(
        iterable.firstNotNullOfOrNull((element) => element.toString()),
        '0',
      );
      expect(
        iterable.firstNotNullOfOrNull((element) => null),
        null,
      );
    });

    test('firstOrNull', () {
      expect([].firstOrNull((element) => element.isOdd), null);
      expect(iterable.firstOrNull(), 0);
      expect(iterable.firstOrNull((element) => element.isOdd), 1);
      expect(
        iterable.firstOrNull((element) => element.isNegative),
        null,
      );
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

  test('foldIndexed', () {
    expect(
      iterable.foldIndexed<int>(
        0,
        (index, previousValue, element) => index + previousValue + element,
      ),
      6,
    );
  });

  test('forEachIndexed', () {
    var i = 0;
    var iterator = iterable.iterator..moveNext();

    iterable.forEachIndexed((index, element) {
      expect(index, i++);
      expect(index, iterator.current);
      iterator.moveNext();
    });
  });

  group('GroupBy', () {
    test('groupBy', () {
      final groupBy = iterable.groupBy((element) => element.isEven);

      expect(groupBy, {
        true: [0, 2],
        false: [1],
      });
    });

    test('groupAndTransformBy', () {
      final grogroupAndTransformBy = iterable.groupAndTransformBy(
        (element) => element.isEven,
        (element) => element.toString(),
      );

      expect(grogroupAndTransformBy, {
        true: ['0', '2'],
        false: ['1'],
      });
    });
  });

  group('IndexOf', () {
    test('indexOf', () {
      expect(iterable.indexOf(-1), -1);
      expect(iterable.indexOf(0), 0);
      expect(iterable.indexOf(2), 2);
      expect(iterable.indexOf(3), -1);
    });

    test('indexOfFirst', () {
      expect(iterable.indexOfFirst((element) => element.isNegative), -1);
      expect(iterable.indexOfFirst((element) => element.isEven), 0);
    });

    test('indexOfLast', () {
      expect(iterable.indexOfLast((element) => element.isNegative), -1);
      expect(iterable.indexOfLast((element) => element.isEven), 2);
    });

    test('lastIndexOf', () {
      iterable = [0, 0, 1, 1, 2, 2];

      expect(iterable.lastIndexOf(-1), -1);
      expect(iterable.lastIndexOf(0), 1);
      expect(iterable.lastIndexOf(2), 5);
      expect(iterable.lastIndexOf(3), -1);
    });
  });

  test('intersect', () {
    expect(iterable.intersect([1, 2]), <int>{1, 2});
    expect(iterable.intersect([2, 3]), <int>{2});
    expect(iterable.intersect([3, 4]), <int>{});
    expect(iterable.intersect([1, 1]), <int>{1});
  });

  test('joinToString', () {
    final iterable = [
      'apple',
      'banana',
      'cherry',
      'durian',
      'fig',
      'grape',
      'honeydew',
    ];
    final result1 = iterable.joinToString();
    final result2 = iterable.joinToString(limit: 3);
    final result3 = iterable.joinToString(
      prefix: 'fruits: ',
      postfix: 'delicious',
      separator: ' & ',
      transform: (element) => element.toUpperCase(),
      truncated: 'more... ',
      limit: 3,
    );

    expect(
      result1,
      'apple, banana, cherry, durian, fig, grape, honeydew',
    );
    expect(
      result2,
      'apple, banana, cherry, ...',
    );
    expect(
      result3,
      'fruits: APPLE & BANANA & CHERRY & more... delicious',
    );
  });

  test('lastOrNull', () {
    expect([].lastOrNull(), null);
    expect(iterable.lastOrNull(), 2);
    expect(iterable.lastOrNull((element) => element.isOdd), 1);
    expect(iterable.lastOrNull((element) => element.isNegative), null);
  });

  group('map', () {
    test('mapIndexed', () {
      final result = iterable.mapIndexed((index, element) => index + element);

      expect(result, [0, 2, 4]);
    });

    test('mapIndexedNotNull', () {
      final result = iterable.mapIndexedNotNull(
        (index, element) => (index * element).isEven ? null : element,
      );

      expect(result, [1]);
    });

    test('mapNotNull', () {
      final result = iterable.mapNotNull(
        (element) => element.isEven ? null : element,
      );

      expect(result, [1]);
    });
  });

  group('Max', () {
    test('maxOrNull', () {
      expect(<num>[].maxOrNull, null);
      expect(iterable.maxOrNull, 2);
    });

    test('maxByOrNull', () {
      final iterable = [
        [1],
        [1, 2],
        [1, 2, 3],
      ];
      Comparable selector(List element) => element.length;

      expect(<List>[].maxByOrNull(selector), null);
      expect(
          [
            [3]
          ].maxByOrNull(selector),
          [3]);
      expect(iterable.maxByOrNull(selector), [1, 2, 3]);
    });

    test('maxOf', () {
      final iterable = [
        [1],
        [1, 2],
        [1, 2, 3],
      ];

      Comparable selector(List element) => element.length;

      expect(
        () => <List>[].maxOf(selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(
        [
          [3]
        ].maxOf(selector),
        1,
      );
      expect(iterable.maxOf(selector), 3);
    });

    test('maxOfOrNull', () {
      final iterable = [
        [1],
        [1, 2],
        [1, 2, 3],
      ];

      Comparable selector(List element) => element.length;

      expect(<List>[].maxOfOrNull(selector), null);
      expect(
        [
          [3]
        ].maxOfOrNull(selector),
        1,
      );
      expect(iterable.maxOfOrNull(selector), 3);
    });

    test('maxOfWith', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(
        () => <int>[].maxOfWith(comparator, selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect([3].maxOfWith(comparator, selector), -3);
      expect(iterable.maxOfWith(comparator, selector), 0);
    });

    test('maxOfWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(<int>[].maxOfWithOrNull(comparator, selector), null);
      expect([3].maxOfWithOrNull(comparator, selector), -3);
      expect(iterable.maxOfWithOrNull(comparator, selector), 0);
    });

    test('maxWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);

      expect(<int>[].maxWithOrNull(comparator), null);
      expect([3].maxWithOrNull(comparator), 3);
      expect(iterable.maxWithOrNull(comparator), 2);
    });
  });

  group('Min', () {
    test('minOrNull', () {
      expect(<num>[].minOrNull, null);
      expect(iterable.minOrNull, 0);
    });

    test('minByOrNull', () {
      final iterable = [
        [1],
        [1, 2],
        [1, 2, 3],
      ];
      Comparable selector(List element) => element.length;

      expect(<List>[].minByOrNull(selector), null);
      expect(
          [
            [3]
          ].minByOrNull(selector),
          [3]);
      expect(iterable.minByOrNull(selector), [1]);
    });

    test('minOf', () {
      final iterable = [
        [1],
        [1, 2],
        [1, 2, 3],
      ];

      Comparable selector(List element) => element.length;

      expect(
        () => <List>[].minOf(selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(
        [
          [3]
        ].minOf(selector),
        1,
      );
      expect(iterable.minOf(selector), 1);
    });

    test('minOfOrNull', () {
      final iterable = [
        [1],
        [1, 2],
        [1, 2, 3],
      ];

      Comparable selector(List element) => element.length;

      expect(<List>[].minOfOrNull(selector), null);
      expect(
        [
          [3]
        ].minOfOrNull(selector),
        1,
      );
      expect(iterable.minOfOrNull(selector), 1);
    });

    test('minOfWith', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(
        () => <int>[].minOfWith(comparator, selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect([3].minOfWith(comparator, selector), -3);
      expect(iterable.minOfWith(comparator, selector), -2);
    });

    test('minOfWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(<int>[].minOfWithOrNull(comparator, selector), null);
      expect([3].minOfWithOrNull(comparator, selector), -3);
      expect(iterable.minOfWithOrNull(comparator, selector), -2);
    });

    test('minWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);

      expect(<int>[].minWithOrNull(comparator), null);
      expect([3].minWithOrNull(comparator), 3);
      expect(iterable.minWithOrNull(comparator), 0);
    });
  });

  test('none', () {
    expect([].none(), true);
    expect(iterable.none(), false);
    expect([].none((element) => element == null), true);
    expect(iterable.none((element) => element.isNegative), true);
    expect(iterable.none((element) => element.isEven), false);
  });

  group('OnEach', () {
    test('onEach', () {
      var idx = 0;
      final iter = iterable.onEach((element) {
        expect(element, idx++);
      });
      expect(iter, iterable);
    });

    test('onEachIndexed', () {
      var idx = 0;
      final iter = iterable.onEachIndexed((index, element) {
        expect(element, idx);
        expect(index, idx);
        idx++;
      });
      expect(iter, iterable);
    });
  });

  test('partition', () {
    final partition = iterable.partition((element) => element.isEven);

    expect(partition.first, [0, 2]);
    expect(partition.second, [1]);
  });

  group('Reduce', () {
    test('reduceIndexed', () {
      int combine(int index, int value, int element) => index + value + element;

      expect(
        () => <int>[].reduceIndexed(combine),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(iterable.reduceIndexed(combine), 4);
    });

    test('reduceIndexedOrNull', () {
      int combine(int index, int value, int element) => index + value + element;

      expect(<int>[].reduceIndexedOrNull(combine), null);
      expect(iterable.reduceIndexedOrNull(combine), 4);
    });

    test('reduceOrNull', () {
      int combine(int value, int element) => value + element;

      expect(<int>[].reduceOrNull(combine), null);
      expect(iterable.reduceOrNull(combine), 3);
    });
  });

  test('requireNoNulls', () {
    expect(<int?>[0, 1, 2].requireNoNulls, [0, 1, 2]);
    expect(
      () => <int?>[0, null, 2].requireNoNulls,
      throwsA(isArgumentError),
    );
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

  group('operator', () {
    test('minus', () {
      expect([] - [1], []);
      expect([1] - [], [1]);
      expect([1] - [1], []);
      expect([1] - [1, 2], []);
      expect([1, 2] - [1], [2]);
      expect([1, 2] - [1, 3], [2]);
      expect([1, 2] - [3, 4], [1, 2]);
      expect([1, 1, 2] - [1], [2]);
      expect([1, 1, 2] - [1, 2], []);
    });

    test('minus assign', () {
      Iterable iterable = [1, 1, 2];

      iterable -= [];
      expect(iterable, [1, 1, 2]);
      iterable -= [3, 4];
      expect(iterable, [1, 1, 2]);
      iterable -= [2, 3];
      expect(iterable, [1, 1]);
      iterable -= [1];
      expect(iterable, []);
      iterable -= [1];
      expect(iterable, []);
    });

    test('plus', () {
      expect([] + [2], [2]);
      expect([1] + [], [1]);
      expect([1] + [2], [1, 2]);
      expect([2] + [1], [2, 1]);
      expect([1] + [1, 2], [1, 1, 2]);
      expect([1, 2] + [1], [1, 2, 1]);
      expect([1, 2] + [3, 4], [1, 2, 3, 4]);
    });

    test('plus assign', () {
      Iterable iterable = [];

      iterable += [1];
      expect(iterable, [1]);
      iterable += [2, 3];
      expect(iterable, [1, 2, 3]);
      iterable += [2, 3];
      expect(iterable, [1, 2, 3, 2, 3]);
      iterable += [4, 4];
      expect(iterable, [1, 2, 3, 2, 3, 4, 4]);
      iterable += [];
      expect(iterable, [1, 2, 3, 2, 3, 4, 4]);
    });

    test('shift left', () {
      expect(() => iterable << -1, throwsA(isArgumentError));
      expect(iterable << 0, [0, 1, 2]);
      expect(iterable << 1, [1, 2]);
      expect(iterable << 2, [2]);
      expect(iterable << 3, []);
      expect(iterable << 4, []);
    });

    test('shift right', () {
      expect(() => iterable >> -1, throwsA(isArgumentError));
      expect(iterable >> 0, [0, 1, 2]);
      expect(iterable >> 1, [0, 1]);
      expect(iterable >> 2, [0]);
      expect(iterable >> 3, []);
      expect(() => iterable >> 4, throwsA(isRangeError));
    });
  });
}
