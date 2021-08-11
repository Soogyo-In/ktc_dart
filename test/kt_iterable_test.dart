import 'package:test/scaffolding.dart';
import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  final Iterable<int> empty = Iterable.empty();
  late Iterable<int> iterable;
  late Iterable<int> reversedIterable;

  setUp(() {
    iterable = Iterable.generate(3);
    reversedIterable = Iterable.generate(
      3,
      (index) => 2 - index,
    );
  });

  test('average', () {
    expect(empty.average, 0.0);
    expect(Iterable.generate(2, (index) => index + 1).average, 1.5);
    expect(
      Iterable.generate(2, (index) => (index + 1).toDouble()).average,
      1.5,
    );
    expect(Iterable.generate(2, (index) => double.nan).average, isNaN);
    expect(Iterable.generate(2, (index) => 0 / index).average, isNaN);
    expect(
      Iterable.generate(2, (index) => (0 / index).toDouble()).average,
      isNaN,
    );
    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? index.toDouble() : index,
      ).average,
      0.5,
    );
    expect(Iterable.generate(2, (index) => 0).average, 0.0);

    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? -index : index,
      ).average,
      -0.5,
    );
    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? -index : index,
      ).average,
      -0.5,
    );
    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? -double.nan : double.nan,
      ).average,
      isNaN,
    );
    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? -index.toDouble() : double.nan,
      ).average,
      isNaN,
    );
    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? -index : double.nan,
      ).average,
      isNaN,
    );
    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? -index.toDouble() : index,
      ).average,
      -0.5,
    );
    expect(
      Iterable.generate(
        2,
        (index) => index.isOdd ? -0.0 : 0.0,
      ).average,
      0.0,
    );
  });

  group('Associate', () {
    test('associate', () {
      MapEntry transform(int element) => MapEntry(
            element.toString(),
            element * 2,
          );

      expect(empty.associate(transform), {});
      expect(
        iterable.associate(transform),
        {'0': 0, '1': 2, '2': 4},
      );
    });

    test('associateBy', () {
      String keySelector(int element) => element.toString();

      expect(empty.associateBy(keySelector), {});
      expect(iterable.associateBy(keySelector), {'0': 0, '1': 1, '2': 2});
    });

    test('associateAndTransformBy', () {
      String keySelector(int element) => element.toString();
      int valueTransform(int element) => element * 2;

      expect(empty.associateAndTransformBy(keySelector, valueTransform), {});
      expect(
        iterable.associateAndTransformBy(keySelector, valueTransform),
        {'0': 0, '1': 2, '2': 4},
      );
    });

    test('associaateWith', () {
      String valueSelector(int element) => element.toString();

      expect(empty.associateWith(valueSelector), {});
      expect(iterable.associateWith(valueSelector), {0: '0', 1: '1', 2: '2'});
    });
  });

  group('Chunked', () {
    test('chunked', () {
      expect(() => empty.chunked(-1), throwsArgumentError);
      expect(() => empty.chunked(0), throwsArgumentError);
      expect(empty.chunked(1), []);
      expect(() => iterable.chunked(-1), throwsArgumentError);
      expect(() => iterable.chunked(0), throwsArgumentError);
      expect(iterable.chunked(1), [
        [0],
        [1],
        [2],
      ]);
      expect(iterable.chunked(2), [
        [0, 1],
        [2],
      ]);
      expect(iterable.chunked(3), [
        [0, 1, 2]
      ]);
      expect(iterable.chunked(4), [
        [0, 1, 2]
      ]);
    });

    test('chunkedAndTransform', () {
      expect(empty, []);
      expect(
        iterable.chunkedAndTransform(
          2,
          (chunk) => chunk.reduce((value, element) => value + element),
        ),
        [1, 2],
      );
    });
  });

  test('count', () {
    expect(empty.count(), 0);
    expect(iterable.count(), 3);
    expect(iterable.count((element) => element.isEven), 2);
  });

  group('Distinct', () {
    test('distinct', () {
      expect(empty.distinct, []);
      expect(Iterable.generate(2, (index) => 0).distinct, [0]);
    });

    test('distinctBy', () {
      bool selector(int element) => element.isEven;

      expect(empty.distinctBy(selector), []);
      expect(iterable.distinctBy(selector), [0, 1]);
    });
  });

  group('ElementAt', () {
    test('ElementAtOrElse', () {
      int orElse(int index) => -index;

      expect(empty.elementAtOrElse(0, orElse), -0);
      expect(iterable.elementAtOrElse(0, orElse), 0);
      expect(iterable.elementAtOrElse(2, orElse), 2);
      expect(iterable.elementAtOrElse(-1, orElse), 1);
      expect(iterable.elementAtOrElse(3, orElse), -3);
    });

    test('ElementAtOrNull', () {
      expect(empty.elementAtOrNull(0), null);
      expect(iterable.elementAtOrNull(0), 0);
      expect(iterable.elementAtOrNull(2), 2);
      expect(iterable.elementAtOrNull(-1), null);
      expect(iterable.elementAtOrNull(3), null);
    });
  });

  test('expandIndexed', () {
    Iterable<int> transform(int index, int element) => [index, element];

    expect(empty.expandIndexed(transform), []);
    expect(iterable.expandIndexed(transform), [0, 0, 1, 1, 2, 2]);
  });

  group('First', () {
    test('firstNotNullOf', () {
      expect(
        () => empty.firstNotNullOf((element) => element),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(iterable.firstNotNullOf((element) => element.toString()), '0');
      expect(
        () => iterable.firstNotNullOf((element) => null),
        throwsA(isA<NoSuchElementException>()),
      );
    });

    test('firstNotNullOfOrNull', () {
      expect(empty.firstNotNullOfOrNull((element) => element), null);
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
      expect(empty.firstOrNull, null);
      expect(iterable.firstOrNull, 0);
    });

    test('firstWhereOrNull', () {
      expect(empty.firstWhereOrNull((element) => element.isEven), null);
      expect(iterable.firstWhereOrNull((element) => element.isEven), 0);
      expect(iterable.firstWhereOrNull((element) => element.isNegative), null);
    });
  });

  test('flatten', () {
    expect(Iterable.generate(1, (index) => Iterable.empty()).flatten, []);
    expect(
      Iterable.generate(
        2,
        (i) => Iterable.generate(2, (j) => i + j),
      ).flatten,
      [0, 1, 1, 2],
    );

    expect(
      Iterable.generate(
        2,
        (index) => index == 0
            ? Iterable.generate(2)
            : Iterable.generate(
                1,
                (index) => Iterable.generate(2),
              ),
      ).flatten,
      [
        0,
        1,
        [0, 1]
      ],
    );
  });

  group('Fold', () {
    test('foldIndexed', () {
      int combine(int index, int previousValue, int element) =>
          index + previousValue + element;

      expect(empty.foldIndexed<int>(0, combine), 0);
      expect(iterable.foldIndexed<int>(0, combine), 6);
    });

    test('runningFold', () {
      final initialValue = 'start';
      String combine(String previousValue, int element) =>
          '$previousValue$element';

      expect(empty.runningFold(initialValue, combine), ['start']);
      expect(
        iterable.runningFold(initialValue, combine),
        ['start', 'start0', 'start01', 'start012'],
      );
    });

    test('runningFoldIndexed', () {
      final initialValue = 'start';
      String combine(int index, String previousValue, int element) =>
          '$previousValue$element$index';

      expect(empty.runningFoldIndexed(initialValue, combine), ['start']);
      expect(
        iterable.runningFoldIndexed(initialValue, combine),
        ['start', 'start00', 'start0011', 'start001122'],
      );
    });
  });

  test('forEachIndexed', () {
    var i = 0;
    var iterator = iterable.iterator..moveNext();
    void action(int index, int element) {
      expect(index, i++);
      expect(index, iterator.current);
      iterator.moveNext();
    }

    empty.forEachIndexed(action);
    iterable.forEachIndexed(action);
  });

  group('GroupBy', () {
    test('groupBy', () {
      bool keySelector(int element) => element.isEven;

      expect(empty.groupBy(keySelector), {});
      expect(iterable.groupBy(keySelector), {
        true: [0, 2],
        false: [1],
      });
    });

    test('groupAndTransformBy', () {
      bool keySelector(int element) => element.isEven;
      String valueTransform(int element) => element.toString();

      expect(
        empty.groupAndTransformBy(keySelector, valueTransform),
        {},
      );
      expect(iterable.groupAndTransformBy(keySelector, valueTransform), {
        true: ['0', '2'],
        false: ['1'],
      });
    });
  });

  group('IndexOf', () {
    test('indexOf', () {
      expect(empty.indexOf(0), -1);
      expect(iterable.indexOf(-1), -1);
      expect(iterable.indexOf(0), 0);
      expect(iterable.indexOf(2), 2);
      expect(iterable.indexOf(3), -1);
    });

    test('indexOfFirst', () {
      expect(empty.indexOfFirst((element) => element.isNegative), -1);
      expect(iterable.indexOfFirst((element) => element.isNegative), -1);
      expect(iterable.indexOfFirst((element) => element.isEven), 0);
    });

    test('indexOfLast', () {
      expect(empty.indexOfLast((element) => element.isNegative), -1);
      expect(iterable.indexOfLast((element) => element.isNegative), -1);
      expect(iterable.indexOfLast((element) => element.isEven), 2);
    });

    test('lastIndexOf', () {
      iterable = Iterable<Iterable<int>>.generate(
        3,
        (index) => Iterable<int>.generate(2, (_) => index),
      ).flatten;
      // [0, 0, 1, 1, 2, 2];

      expect(empty.lastIndexOf(0), -1);
      expect(iterable.lastIndexOf(-1), -1);
      expect(iterable.lastIndexOf(0), 1);
      expect(iterable.lastIndexOf(2), 5);
      expect(iterable.lastIndexOf(3), -1);
    });
  });

  test('intersect', () {
    expect(empty.intersect([1, 2]), <int>[]);
    expect(iterable.intersect([1, 2]), <int>[1, 2]);
    expect(iterable.intersect([2, 3]), <int>[2]);
    expect(iterable.intersect([3, 4]), <int>[]);
    expect(iterable.intersect([1, 1]), <int>[1]);
    expect(
      Iterable.generate(
        6,
        (index) => index.isOdd ? index - 1 : index,
      ).intersect([1, 2, 3, 4]),
      <int>[2, 4],
    );
  });

  test('joinToString', () {
    final iterable = Iterable.generate(6, (index) => index.toString());

    expect(empty.joinToString(), '');
    expect(
      iterable.joinToString(),
      '0, 1, 2, 3, 4, 5',
    );
    expect(empty.joinToString(limit: 3), '');
    expect(
      iterable.joinToString(limit: 3),
      '0, 1, 2, ...',
    );
    expect(
        empty.joinToString(
          prefix: 'start ',
          postfix: 'end',
          separator: ' & ',
          transform: (element) => '-$element',
          truncated: 'more... ',
          limit: 3,
        ),
        'start end');
    expect(
      iterable.joinToString(
        prefix: 'start ',
        postfix: 'end',
        separator: ' & ',
        transform: (element) => '-$element',
        truncated: 'more... ',
        limit: 3,
      ),
      'start -0 & -1 & -2 & more... end',
    );
  });

  group('Last', () {
    test('lastOrNull', () {
      expect(empty.lastOrNull, null);
      expect(iterable.lastOrNull, 2);
    });

    test('lastWhereOrNull', () {
      expect(empty.lastWhereOrNull((element) => element.isEven), null);
      expect(iterable.lastWhereOrNull((element) => element.isEven), 2);
      expect(iterable.lastWhereOrNull((element) => element.isNegative), null);
    });
  });

  group('Map', () {
    test('mapIndexed', () {
      int transform(int index, int element) => index + element;

      expect(empty.mapIndexed(transform), []);
      expect(iterable.mapIndexed(transform), [0, 2, 4]);
    });

    test('mapIndexedNotNull', () {
      int? transform(int index, int element) =>
          (index * element).isEven ? null : element;

      expect(empty.mapIndexedNotNull(transform), []);
      expect(iterable.mapIndexedNotNull(transform), [1]);
    });

    test('mapNotNull', () {
      int? transform(int element) => element.isEven ? null : element;

      expect(empty.mapNotNull(transform), []);
      expect(iterable.mapNotNull(transform), [1]);
    });
  });

  group('Max', () {
    test('maxOrNull', () {
      expect(empty.maxOrNull, null);
      expect(iterable.maxOrNull, 2);
    });

    test('maxByOrNull', () {
      final iterable = Iterable.generate(
        3,
        (index) => Iterable<int>.generate(index + 1),
      );
      Comparable selector(Iterable<int> element) => element.length;

      expect(Iterable<Iterable<int>>.empty().maxByOrNull(selector), null);
      expect(
        Iterable.generate(
          1,
          (index) => Iterable<int>.generate(1),
        ).maxByOrNull(selector),
        [0],
      );
      expect(iterable.maxByOrNull(selector), [0, 1, 2]);
    });

    test('maxOf', () {
      final iterable = Iterable.generate(
        3,
        (index) => Iterable<int>.generate(index + 1),
      );
      Comparable selector(Iterable<int> element) => element.length;

      expect(
        () => Iterable<Iterable<int>>.empty().maxOf(selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(
        Iterable.generate(
          1,
          (index) => Iterable<int>.generate(1),
        ).maxOf(selector),
        1,
      );
      expect(iterable.maxOf(selector), 3);
    });

    test('maxOfOrNull', () {
      final iterable = Iterable.generate(
        3,
        (index) => Iterable<int>.generate(index + 1),
      );
      Comparable selector(Iterable<int> element) => element.length;

      expect(Iterable<Iterable<int>>.empty().maxOfOrNull(selector), null);
      expect(
        Iterable.generate(
          1,
          (index) => Iterable<int>.generate(1),
        ).maxOf(selector),
        1,
      );
      expect(iterable.maxOf(selector), 3);
    });

    test('maxOfWith', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(
        () => Iterable<int>.empty().maxOfWith(comparator, selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(
        Iterable.generate(1, (_) => 3).maxOfWith(comparator, selector),
        -3,
      );
      expect(iterable.maxOfWith(comparator, selector), 0);
    });

    test('maxOfWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(Iterable<int>.empty().maxOfWithOrNull(comparator, selector), null);
      expect(
        Iterable.generate(1, (_) => 3).maxOfWithOrNull(comparator, selector),
        -3,
      );
      expect(iterable.maxOfWithOrNull(comparator, selector), 0);
    });

    test('maxWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);

      expect(Iterable<int>.empty().maxWithOrNull(comparator), null);
      expect(Iterable.generate(1, (_) => 3).maxWithOrNull(comparator), 3);
      expect(iterable.maxWithOrNull(comparator), 2);
    });
  });

  group('Min', () {
    test('minOrNull', () {
      expect(empty.minOrNull, null);
      expect(iterable.minOrNull, 0);
    });

    test('minByOrNull', () {
      final iterable = Iterable.generate(
        3,
        (index) => Iterable<int>.generate(index + 1),
      );
      Comparable selector(Iterable<int> element) => element.length;

      expect(Iterable<Iterable<int>>.empty().minByOrNull(selector), null);
      expect(
        Iterable.generate(
          1,
          (index) => Iterable<int>.generate(1),
        ).minByOrNull(selector),
        [0],
      );
      expect(iterable.minByOrNull(selector), [0]);
    });

    test('minOf', () {
      final iterable = Iterable.generate(
        3,
        (index) => Iterable<int>.generate(index + 1),
      );
      Comparable selector(Iterable<int> element) => element.length;

      expect(
        () => Iterable<Iterable<int>>.empty().minOf(selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(
        Iterable.generate(
          1,
          (index) => Iterable<int>.generate(1),
        ).minOf(selector),
        1,
      );
      expect(iterable.minOf(selector), 1);
    });

    test('minOfOrNull', () {
      final iterable = Iterable.generate(
        3,
        (index) => Iterable<int>.generate(index + 1),
      );
      Comparable selector(Iterable<int> element) => element.length;

      expect(Iterable<Iterable<int>>.empty().minOfOrNull(selector), null);
      expect(
        Iterable.generate(
          1,
          (index) => Iterable<int>.generate(1),
        ).minOfOrNull(selector),
        1,
      );
      expect(iterable.minOfOrNull(selector), 1);
    });

    test('minOfWith', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(
        () => Iterable<int>.empty().minOfWith(comparator, selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(
        Iterable.generate(1, (index) => 3).minOfWith(comparator, selector),
        -3,
      );
      expect(iterable.minOfWith(comparator, selector), -2);
    });

    test('minOfWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(int element) => -element;

      expect(Iterable<int>.empty().minOfWithOrNull(comparator, selector), null);
      expect(
        Iterable.generate(
          1,
          (index) => 3,
        ).minOfWithOrNull(comparator, selector),
        -3,
      );
      expect(iterable.minOfWithOrNull(comparator, selector), -2);
    });

    test('minWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);

      expect(Iterable<int>.empty().minWithOrNull(comparator), null);
      expect(
        Iterable.generate(
          1,
          (index) => 3,
        ).minWithOrNull(comparator),
        3,
      );
      expect(iterable.minWithOrNull(comparator), 0);
    });
  });

  test('none', () {
    expect(empty.none(), true);
    expect(iterable.none(), false);
    expect(Iterable.empty().none((element) => element == null), true);
    expect(iterable.none((element) => element.isNegative), true);
    expect(iterable.none((element) => element.isEven), false);
  });

  group('OnEach', () {
    test('onEach', () {
      var idx = 0;
      void action(int element) => expect(element, idx++);

      expect(empty.onEach(action), empty);
      expect(iterable.onEach(action), iterable);
    });

    test('onEachIndexed', () {
      var idx = 0;
      void action(int index, int element) {
        expect(element, idx);
        expect(index, idx);
        idx++;
      }

      expect(empty.onEachIndexed(action), empty);
      expect(iterable.onEachIndexed(action), iterable);
    });
  });

  test('partition', () {
    bool test(int element) => element.isEven;
    final emptyPartition = empty.partition(test);
    final partition = iterable.partition(test);

    expect(emptyPartition.first, []);
    expect(emptyPartition.second, []);
    expect(partition.first, [0, 2]);
    expect(partition.second, [1]);
  });

  group('Reduce', () {
    test('reduceIndexed', () {
      int combine(int index, int value, int element) => index + value + element;

      expect(
        () => empty.reduceIndexed(combine),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(iterable.reduceIndexed(combine), 6);
    });

    test('reduceIndexedOrNull', () {
      int combine(int index, int value, int element) => index + value + element;

      expect(empty.reduceIndexedOrNull(combine), null);
      expect(iterable.reduceIndexedOrNull(combine), 6);
    });

    test('reduceOrNull', () {
      int combine(int value, int element) => value + element;

      expect(empty.reduceOrNull(combine), null);
      expect(iterable.reduceOrNull(combine), 3);
    });

    test('runningReduce', () {
      int combine(previousValue, element) => previousValue + element;

      expect(empty.runningReduce(combine), []);
      expect(iterable.runningReduce(combine), [1, 3]);
    });

    test('runningReduceIndexed', () {
      int combine(index, previousValue, element) =>
          previousValue + element + index;

      expect(empty.runningReduceIndexed(combine), []);
      expect(iterable.runningReduceIndexed(combine), [2, 6]);
    });
  });

  test('requireNoNulls', () {
    expect(Iterable<int?>.generate(3).requireNoNulls, [0, 1, 2]);
    expect(
      () => Iterable<int?>.generate(
        3,
        (index) => index.isOdd ? null : index,
      ).requireNoNulls,
      throwsA(isArgumentError),
    );
  });

  test('reversed', () {
    expect(iterable.reversed, [2, 1, 0]);
  });

  group('Single', () {
    test('singleOrNull', () {
      expect(empty.singleOrNull, null);
      expect(Iterable<int>.generate(1).singleOrNull, 0);
      expect(Iterable<int>.generate(2).singleOrNull, null);
    });

    test('singleWhrerOrNull', () {
      bool test(int element) => element == 1;

      expect(empty.singleWhereOrNull(test), null);
      expect(
        Iterable<int>.generate(2, (index) => index * 2).singleWhereOrNull(test),
        null,
      );
      expect(Iterable<int>.generate(3).singleWhereOrNull(test), 1);
      expect(
        Iterable<int>.generate(2, (index) => 1).singleWhereOrNull(test),
        null,
      );
    });
  });

  group('Sort', () {
    test('sorted', () {
      expect(reversedIterable.sorted, [0, 1, 2]);
    });

    test('sortedBy', () {
      expect(iterable.sortedBy((element) => -element), [2, 1, 0]);
    });

    test('sortedByDescending', () {
      expect(iterable.sortedByDescending((element) => -element), [0, 1, 2]);
    });

    test('sortedDescending', () {
      expect(iterable.sortedDescending, [2, 1, 0]);
    });

    test('sortedWith', () {
      expect(
        reversedIterable.sortedWith((a, b) => a.compareTo(b)),
        [0, 1, 2],
      );
      expect(iterable.sortedWith((a, b) => b.compareTo(a)), [2, 1, 0]);
    });
  });

  group('Sum', () {
    final iterable = Iterable<num>.generate(
      3,
      (index) => index.isOdd ? index.toDouble() : index,
    );
    test('sum', () {
      expect(empty.sum, 0);
      expect(iterable.sum, 3);
    });

    test('sumOf', () {
      num selector(num element) => -element;

      expect(empty.sumOf(selector), 0);
      expect(iterable.sumOf(selector), -3.0);
    });
  });

  test('union', () {
    expect(empty.union([1]), [1]);
    expect(Iterable.generate(1).union([0]), [0]);
    expect(Iterable.generate(1).union([0, 1]), [0, 1]);
    expect(Iterable.generate(2).union([1, 2]), [0, 1, 2]);
    expect(Iterable.generate(2).union([2, 3]), [0, 1, 2, 3]);
    expect(
      Iterable.generate(
        3,
        (index) => index.isEven ? 0 : index,
      ).union([]),
      [0, 1],
    );
    expect(
      Iterable.generate(
        3,
        (index) => index.isEven ? 0 : index,
      ).union([1, 0]),
      [0, 1],
    );
  });

  test('unzip', () {
    final emptyUnzip = Iterable<Pair>.empty().unzip();
    final unzip = Iterable.generate(3, (index) => Pair(index, -index)).unzip();

    expect(emptyUnzip.first, Iterable<int>.empty());
    expect(emptyUnzip.second, Iterable<int>.empty());
    expect(unzip.first, Iterable<int>.generate(3));
    expect(unzip.second, Iterable<int>.generate(3, (index) => -index));
  });

  group('Where', () {
    test('whereIndexed', () {
      bool test(int index, int element) => (index + element).isEven;

      expect(empty.whereIndexed(test), []);
      expect(iterable.whereIndexed(test), [0, 1, 2]);
    });

    test('whereIsInstance', () {
      final iterable = Iterable.generate(
        3,
        (index) => index.isOdd ? index.toString() : index,
      );

      expect(empty.whereIsInstance<String>(), []);
      expect(iterable.whereIsInstance<String>(), ['1']);
    });

    test('whereNot', () {
      bool test(int element) => element.isEven;

      expect(empty.whereNot(test), []);
      expect(iterable.whereNot(test), [1]);
    });

    test('whereNotNull', () {
      final iterable = Iterable.generate(
        4,
        (index) => index.isEven ? null : index,
      );

      expect(empty.whereNotNull, []);
      expect(iterable.whereNotNull, [1, 3]);
    });
  });

  group('Windowed', () {
    test('windowed', () {
      final iterable = Iterable.generate(10);

      expect(empty.windowed(size: 1), []);
      expect(
        () => iterable.windowed(size: -1, step: -1),
        throwsArgumentError,
      );
      expect(
        () => iterable.windowed(size: 0, step: -1),
        throwsArgumentError,
      );
      expect(
        () => iterable.windowed(size: 0, step: 0),
        throwsArgumentError,
      );
      expect(
        () => iterable.windowed(size: 1, step: 0),
        throwsArgumentError,
      );
      expect(
        iterable.windowed(size: 5),
        [
          [0, 1, 2, 3, 4],
          [1, 2, 3, 4, 5],
          [2, 3, 4, 5, 6],
          [3, 4, 5, 6, 7],
          [4, 5, 6, 7, 8],
          [5, 6, 7, 8, 9],
        ],
      );
      expect(
        iterable.windowed(size: 5, step: 3),
        [
          [0, 1, 2, 3, 4],
          [3, 4, 5, 6, 7],
        ],
      );
      expect(
        iterable.windowed(
          size: 5,
          step: 3,
          partialWindows: true,
        ),
        [
          [0, 1, 2, 3, 4],
          [3, 4, 5, 6, 7],
          [6, 7, 8, 9],
          [9],
        ],
      );
    });

    test('windowedAndTransform', () {
      final iterable = Iterable<int>.generate(10);
      int transform(Iterable<int> chunk) =>
          chunk.reduce((value, element) => value + element);

      expect(empty.windowedAndTransform(size: 1, transform: transform), []);
      expect(
        () => iterable.windowedAndTransform(
          size: -1,
          step: -1,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => iterable.windowedAndTransform(
          size: 0,
          step: -1,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => iterable.windowedAndTransform(
          size: 0,
          step: 0,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => iterable.windowedAndTransform(
          size: 1,
          step: 0,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        iterable.windowedAndTransform(size: 5, transform: transform),
        [10, 15, 20, 25, 30, 35],
      );
      expect(
        iterable.windowedAndTransform(
          size: 5,
          step: 3,
          transform: transform,
        ),
        [10, 25],
      );
      expect(
        iterable.windowedAndTransform(
          size: 5,
          step: 3,
          transform: transform,
          partialWindows: true,
        ),
        [10, 25, 30, 9],
      );
    });
  });

  test('withIndex', () {
    expect(iterable.withIndex, [
      IndexedValue(0, 0),
      IndexedValue(1, 1),
      IndexedValue(2, 2),
    ]);
  });

  group('Zip', () {
    test('zip', () {
      expect(
        iterable.zip(['0', '1', '2', '3']),
        [Pair(0, '0'), Pair(1, '1'), Pair(2, '2')],
      );
    });

    test('zipAndTransform', () {
      expect(
        iterable.zipAndTransform(
          ['0', '1', '2', '3'],
          (pair) => '${pair.first}${pair.second}',
        ),
        ['00', '11', '22'],
      );
    });

    test('zipWithNext', () {
      expect(iterable.zipWithNext, [Pair(0, 1), Pair(1, 2)]);
    });

    test('zipWithNextAndTransform', () {
      expect(
        iterable.zipWithNextAndTransform(
          (pair) => '${pair.first}${pair.second}',
        ),
        ['01', '12'],
      );
    });
  });

  group('Operator', () {
    test('-', () {
      expect(empty - [0], []);
      expect(Iterable.generate(1) - [], [0]);
      expect(Iterable.generate(1) - [0], []);
      expect(Iterable.generate(1) - [0, 1], []);
      expect(Iterable.generate(2) - [0], [1]);
      expect(Iterable.generate(2) - [0, 2], [1]);
      expect(Iterable.generate(2) - [2, 3], [0, 1]);
      expect(
        Iterable.generate(3, (index) => index.isOdd ? index - 1 : index) - [0],
        [2],
      );
      expect(
        Iterable.generate(3, (index) => index.isOdd ? index - 1 : index) -
            [0, 2],
        [],
      );
    });

    test('+', () {
      expect(empty + [0], [0]);
      expect(Iterable.generate(1) + [], [0]);
      expect(Iterable.generate(1) + [1], [0, 1]);
      expect(Iterable.generate(1, (index) => index + 1) + [0], [1, 0]);
      expect(Iterable.generate(1) + [0, 1], [0, 0, 1]);
      expect(Iterable.generate(2) + [0], [0, 1, 0]);
      expect(Iterable.generate(2) + [2, 3], [0, 1, 2, 3]);
    });

    test('<<', () {
      expect(empty << 1, []);
      expect(() => iterable << -1, throwsA(isArgumentError));
      expect(iterable << 0, [0, 1, 2]);
      expect(iterable << 1, [1, 2]);
      expect(iterable << 2, [2]);
      expect(iterable << 3, []);
      expect(iterable << 4, []);
    });

    test('>>', () {
      expect(empty >> 1, []);
      expect(() => iterable >> -1, throwsA(isArgumentError));
      expect(iterable >> 0, [0, 1, 2]);
      expect(iterable >> 1, [0, 1]);
      expect(iterable >> 2, [0]);
      expect(iterable >> 3, []);
      expect(iterable >> 4, []);
    });

    test('^', () {
      expect(empty ^ [], []);
      expect(Iterable.generate(1) ^ [], [0]);
      expect(Iterable.generate(1) ^ [1], [0, 1]);
      expect(Iterable.generate(2, (_) => 0) ^ [1], [0, 1]);
      expect(Iterable.generate(2, (_) => 0) ^ [1, 1], [0, 1]);
      expect(
        Iterable.generate(
              3,
              (index) => index.isOdd ? index - 1 : index,
            ) ^
            [2, 2, 3],
        [0, 3],
      );
    });
  });
}
