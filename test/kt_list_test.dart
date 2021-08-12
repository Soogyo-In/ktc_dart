import 'package:test/scaffolding.dart';
import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  final empty = <int>[];
  late List<int> list;
  late List<int> reversedList;

  setUp(() {
    list = [0, 1, 2];
    reversedList = [2, 1, 0];
  });

  group('BinarySearch', () {
    test('rangeCheck', () {
      expect(
        () => rangeCheck(
          length: 1,
          fromIndex: -1,
          toIndex: 0,
        ),
        throwsRangeError,
      );
      expect(
        () => rangeCheck(
          length: 1,
          fromIndex: 1,
          toIndex: 0,
        ),
        throwsArgumentError,
      );
      expect(
        () => rangeCheck(
          length: 1,
          fromIndex: 0,
          toIndex: 2,
        ),
        throwsArgumentError,
      );
    });

    test('binarySearch', () {
      expect(empty.binarySearch(), -1);
      expect(empty.binarySearch(element: -1), -1);
      expect(empty.binarySearch(element: 0), -1);
      expect(empty.binarySearch(element: 1), -1);
      expect(list.binarySearch(), -1);
      expect(list.binarySearch(element: -1), -1);
      expect(list.binarySearch(element: 0), 0);
      expect(list.binarySearch(element: 1), 1);
      expect(list.binarySearch(element: 2), 2);
      expect(list.binarySearch(element: 3), -4);
      expect(list.binarySearch(element: 0, fromIndex: 1), -2);
      expect(list.binarySearch(element: 2, toIndex: 2), -3);
      expect(list.binarySearch(element: 1, fromIndex: 1, toIndex: 1), -2);
    });

    test('binarySearchBy', () {
      final empty = <String>[];
      final list = ['0', '1', '2'];
      int selector(String element) => int.parse(element);

      expect(empty.binarySearchBy(selector: selector), -1);
      expect(empty.binarySearchBy(key: -1, selector: selector), -1);
      expect(empty.binarySearchBy(key: 0, selector: selector), -1);
      expect(empty.binarySearchBy(key: 1, selector: selector), -1);
      expect(empty.binarySearchBy(key: -1, selector: (_) => null), -1);
      expect(empty.binarySearchBy(key: 0, selector: (_) => null), -1);
      expect(empty.binarySearchBy(key: 1, selector: (_) => null), -1);
      expect(list.binarySearchBy(selector: selector), -1);
      expect(list.binarySearchBy(key: -1, selector: selector), -1);
      expect(list.binarySearchBy(key: 0, selector: selector), 0);
      expect(list.binarySearchBy(key: 1, selector: selector), 1);
      expect(list.binarySearchBy(key: 2, selector: selector), 2);
      expect(list.binarySearchBy(key: 3, selector: selector), -4);
      expect(list.binarySearchBy(key: -1, selector: (_) => null), -4);
      expect(list.binarySearchBy(key: 0, selector: (_) => null), -4);
      expect(list.binarySearchBy(key: 1, selector: (_) => null), -4);
      expect(list.binarySearchBy(key: 2, selector: (_) => null), -4);
      expect(list.binarySearchBy(key: 3, selector: (_) => null), -4);
    });

    test('binarySearchWithComparator', () {
      expect(
        empty.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: -1,
        ),
        -1,
      );
      expect(
        empty.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 0,
        ),
        -1,
      );
      expect(
        empty.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 1,
        ),
        -1,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: -1,
        ),
        -4,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 0,
        ),
        -4,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 1,
        ),
        1,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 2,
        ),
        -1,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 3,
        ),
        -1,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 0,
          fromIndex: 1,
        ),
        -4,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 2,
          toIndex: 2,
        ),
        -1,
      );
      expect(
        list.binarySearchWithComparator(
          comparator: (e1, e2) => e2.compareTo(e1),
          element: 1,
          fromIndex: 1,
          toIndex: 1,
        ),
        -2,
      );
    });

    test('binarySearchWithComparison', () {
      expect(
        empty.binarySearchWithComparison(
          comparison: (element) => element.compareTo(-1),
        ),
        -1,
      );
      expect(
        empty.binarySearchWithComparison(
          comparison: (element) => element.compareTo(0),
        ),
        -1,
      );
      expect(
        empty.binarySearchWithComparison(
          comparison: (element) => element.compareTo(1),
        ),
        -1,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(-1),
        ),
        -1,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(0),
        ),
        0,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(1),
        ),
        1,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(2),
        ),
        2,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(3),
        ),
        -4,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(0),
          fromIndex: 1,
        ),
        -2,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(2),
          toIndex: 2,
        ),
        -3,
      );
      expect(
        list.binarySearchWithComparison(
          comparison: (element) => element.compareTo(1),
          fromIndex: 1,
          toIndex: 1,
        ),
        -2,
      );
    });
  });

  group('Chunked', () {
    test('chunked', () {
      expect(() => empty.chunked(-1), throwsArgumentError);
      expect(() => empty.chunked(0), throwsArgumentError);
      expect(empty.chunked(1), []);
      expect(() => list.chunked(-1), throwsArgumentError);
      expect(() => list.chunked(0), throwsArgumentError);
      expect(list.chunked(1), [
        [0],
        [1],
        [2],
      ]);
      expect(list.chunked(2), [
        [0, 1],
        [2],
      ]);
      expect(list.chunked(3), [
        [0, 1, 2]
      ]);
      expect(list.chunked(4), [
        [0, 1, 2]
      ]);
    });

    test('chunkedAndTransform', () {
      expect(empty, []);
      expect(
        list.chunkedAndTransform(
          2,
          (chunk) => chunk.reduce((value, element) => value + element),
        ),
        [1, 2],
      );
    });
  });

  test('containsAll', () {
    expect(empty.containsAll(list), false);
    expect(list.containsAll(empty), true);
    expect(list.containsAll(reversedList), true);
    expect(list.containsAll([2]), true);
    expect(list.containsAll([2, 3]), false);
    expect(list.containsAll([3]), false);
  });

  test('count', () {
    expect(empty.count(), 0);
    expect(list.count(), 3);
    expect(list.count((element) => element.isEven), 2);
  });

  group('Distinct', () {
    test('distinct', () {
      expect(empty.distinct, []);
      expect([0, 0].distinct, [0]);
    });

    test('distinctBy', () {
      bool selector(int element) => element.isEven;

      expect(empty.distinctBy(selector), []);
      expect(list.distinctBy(selector), [0, 1]);
    });
  });

  test('expandIndexed', () {
    Iterable<int> transform(int index, int element) => [index, element];

    expect(empty.expandIndexed(transform), []);
    expect(list.expandIndexed(transform), [0, 0, 1, 1, 2, 2]);
  });

  test('flatten', () {
    expect([[]].flatten, []);
    expect(
      [
        [0, 1],
        [1, 2],
      ].flatten,
      [0, 1, 1, 2],
    );

    expect(
      [
        [0, 1],
        [
          [0, 1],
        ],
      ].flatten,
      [
        0,
        1,
        [0, 1]
      ],
    );
  });

  group('GroupBy', () {
    test('groupBy', () {
      bool keySelector(int element) => element.isEven;

      expect(empty.groupBy(keySelector), {});
      expect(list.groupBy(keySelector), {
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
      expect(list.groupAndTransformBy(keySelector, valueTransform), {
        true: ['0', '2'],
        false: ['1'],
      });
    });
  });

  test('indices', () {
    expect(empty.indices, Iterable.empty());
    expect(list.indices, Iterable.generate(3));
  });

  test('intersect', () {
    expect(empty.intersect([1, 2]), <int>[]);
    expect(list.intersect([1, 2]), <int>[1, 2]);
    expect(list.intersect([2, 3]), <int>[2]);
    expect(list.intersect([3, 4]), <int>[]);
    expect(list.intersect([1, 1]), <int>[1]);
    expect(
      [0, 0, 2, 2, 4, 4].intersect([1, 2, 3, 4]),
      <int>[2, 4],
    );
  });

  test('lastIndex', () {
    expect(empty.lastIndex, -1);
    expect(list.lastIndex, 2);
  });

  group('Map', () {
    test('mapIndexed', () {
      int transform(int index, int element) => index + element;

      expect(empty.mapIndexed(transform), []);
      expect(list.mapIndexed(transform), [0, 2, 4]);
    });

    test('mapIndexedNotNull', () {
      int? transform(int index, int element) =>
          (index * element).isEven ? null : element;

      expect(empty.mapIndexedNotNull(transform), []);
      expect(list.mapIndexedNotNull(transform), [1]);
    });

    test('mapNotNull', () {
      int? transform(int element) => element.isEven ? null : element;

      expect(empty.mapNotNull(transform), []);
      expect(list.mapNotNull(transform), [1]);
    });
  });

  group('OnEach', () {
    test('onEach', () {
      var idx = 0;
      void action(int element) => expect(element, idx++);

      expect(empty.onEach(action), empty);
      expect(list.onEach(action), list);
    });

    test('onEachIndexed', () {
      var idx = 0;
      void action(int index, int element) {
        expect(element, idx);
        expect(index, idx);
        idx++;
      }

      expect(empty.onEachIndexed(action), empty);
      expect(list.onEachIndexed(action), list);
    });
  });

  test('partition', () {
    bool test(int element) => element.isEven;
    final emptyPartition = empty.partition(test);
    final partition = list.partition(test);

    expect(emptyPartition.first, []);
    expect(emptyPartition.second, []);
    expect(partition.first, [0, 2]);
    expect(partition.second, [1]);
  });

  group('Reduce', () {
    test('runningReduce', () {
      int combine(previousValue, element) => previousValue + element;

      expect(empty.runningReduce(combine), []);
      expect(list.runningReduce(combine), [1, 3]);
    });

    test('runningReduceIndexed', () {
      int combine(index, previousValue, element) =>
          previousValue + element + index;

      expect(empty.runningReduceIndexed(combine), []);
      expect(list.runningReduceIndexed(combine), [2, 6]);
    });
  });

  test('requireNoNulls', () {
    expect([0, 1, 2].requireNoNulls, [0, 1, 2]);
    expect(
      () => [0, null, 2].requireNoNulls,
      throwsA(isArgumentError),
    );
  });

  group('Sort', () {
    test('sorted', () {
      expect(reversedList.sorted, [0, 1, 2]);
    });

    test('sortedBy', () {
      expect(list.sortedBy((element) => -element), [2, 1, 0]);
    });

    test('sortedByDescending', () {
      expect(list.sortedByDescending((element) => -element), [0, 1, 2]);
    });

    test('sortedDescending', () {
      expect(list.sortedDescending, [2, 1, 0]);
    });

    test('sortedWith', () {
      expect(
        reversedList.sortedWith((a, b) => a.compareTo(b)),
        [0, 1, 2],
      );
      expect(list.sortedWith((a, b) => b.compareTo(a)), [2, 1, 0]);
    });
  });

  test('union', () {
    expect(empty.union([1]), [1]);
    expect([0].union([0]), [0]);
    expect([0].union([0, 1]), [0, 1]);
    expect([0, 1].union([1, 2]), [0, 1, 2]);
    expect([0, 1].union([2, 3]), [0, 1, 2, 3]);
    expect([0, 1, 0].union([]), [0, 1]);
    expect([0, 1, 0].union([1, 0]), [0, 1]);
  });

  test('unzip', () {
    final emptyUnzip = <Pair>[].unzip();
    final unzip = [Pair(0, -0), Pair(1, -1), Pair(2, -2)].unzip();

    expect(emptyUnzip.first, []);
    expect(emptyUnzip.second, []);
    expect(unzip.first, [0, 1, 2]);
    expect(unzip.second, [-0, -1, -2]);
  });

  group('Where', () {
    test('whereIndexed', () {
      bool test(int index, int element) => (index + element).isEven;

      expect(empty.whereIndexed(test), []);
      expect(list.whereIndexed(test), [0, 1, 2]);
    });

    test('whereIsInstance', () {
      expect(empty.whereIsInstance<String>(), []);
      expect([0, '1', 2].whereIsInstance<String>(), ['1']);
    });

    test('whereNot', () {
      bool test(int element) => element.isEven;

      expect(empty.whereNot(test), []);
      expect(list.whereNot(test), [1]);
    });

    test('whereNotNull', () {
      expect(empty.whereNotNull, []);
      expect([null, 1, null, 3].whereNotNull, [1, 3]);
    });
  });

  group('Windowed', () {
    test('windowed', () {
      final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

      expect(empty.windowed(size: 1), []);
      expect(
        () => list.windowed(size: -1, step: -1),
        throwsArgumentError,
      );
      expect(
        () => list.windowed(size: 0, step: -1),
        throwsArgumentError,
      );
      expect(
        () => list.windowed(size: 0, step: 0),
        throwsArgumentError,
      );
      expect(
        () => list.windowed(size: 1, step: 0),
        throwsArgumentError,
      );
      expect(
        list.windowed(size: 5),
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
        list.windowed(size: 5, step: 3),
        [
          [0, 1, 2, 3, 4],
          [3, 4, 5, 6, 7],
        ],
      );
      expect(
        list.windowed(
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
      final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
      int transform(Iterable<int> chunk) =>
          chunk.reduce((value, element) => value + element);

      expect(empty.windowedAndTransform(size: 1, transform: transform), []);
      expect(
        () => list.windowedAndTransform(
          size: -1,
          step: -1,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => list.windowedAndTransform(
          size: 0,
          step: -1,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => list.windowedAndTransform(
          size: 0,
          step: 0,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => list.windowedAndTransform(
          size: 1,
          step: 0,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        list.windowedAndTransform(size: 5, transform: transform),
        [10, 15, 20, 25, 30, 35],
      );
      expect(
        list.windowedAndTransform(
          size: 5,
          step: 3,
          transform: transform,
        ),
        [10, 25],
      );
      expect(
        list.windowedAndTransform(
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
    expect(list.withIndex, [
      IndexedValue(0, 0),
      IndexedValue(1, 1),
      IndexedValue(2, 2),
    ]);
  });

  group('Zip', () {
    test('zip', () {
      expect(
        list.zip(['0', '1', '2', '3']),
        [Pair(0, '0'), Pair(1, '1'), Pair(2, '2')],
      );
    });

    test('zipAndTransform', () {
      expect(
        list.zipAndTransform(
          ['0', '1', '2', '3'],
          (pair) => '${pair.first}${pair.second}',
        ),
        ['00', '11', '22'],
      );
    });

    test('zipWithNext', () {
      expect(list.zipWithNext, [Pair(0, 1), Pair(1, 2)]);
    });

    test('zipWithNextAndTransform', () {
      expect(
        list.zipWithNextAndTransform(
          (pair) => '${pair.first}${pair.second}',
        ),
        ['01', '12'],
      );
    });
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
