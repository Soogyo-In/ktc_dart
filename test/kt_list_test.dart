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

  test('containsAll', () {
    expect(empty.containsAll(list), false);
    expect(list.containsAll(empty), true);
    expect(list.containsAll(reversedList), true);
    expect(list.containsAll([2]), true);
    expect(list.containsAll([2, 3]), false);
    expect(list.containsAll([3]), false);
  });

  group('Drop', () {
    test('dropLast', () {
      expect(() => empty.dropLast(-1), throwsArgumentError);
      expect(empty.dropLast(0), []);
      expect(empty.dropLast(1), []);
      expect(() => list.dropLast(-1), throwsArgumentError);
      expect(list.dropLast(0), [0, 1, 2]);
      expect(list.dropLast(1), [0, 1]);
      expect(list.dropLast(4), []);
    });

    test('dropLastWhile', () {
      expect(empty.dropLastWhile((element) => element > 1), []);
      expect(list.dropLastWhile((element) => element > 1), [0, 1]);
      expect(list.dropLastWhile((element) => element == 1), [0, 1, 2]);
    });
  });

  group('Fold', () {
    test('foldRight', () {
      String combine(String previousValue, int element) =>
          element > 1 ? previousValue : previousValue + element.toString();

      expect(empty.foldRight('', combine), '');
      expect(list.foldRight('', combine), '10');
    });

    test('foldRightIndexed', () {
      String combine(int index, String previousValue, int element) =>
          element > 1
              ? previousValue
              : previousValue + (index + element).toString();

      expect(empty.foldRightIndexed('', combine), '');
      expect(list.foldRightIndexed('', combine), '20');
    });
  });

  test('lastIndex', () {
    expect(empty.lastIndex, -1);
    expect(list.lastIndex, 2);
  });

  group('Random', () {
    test('random', () {
      expect(() => empty.random(), throwsA(isA<NoSuchElementException>()));
    });

    test('randomOrNull', () {
      expect(empty.randomOrNull(), null);
    });
  });

  test('slice', () {
    expect(() => empty.slice([0]), throwsRangeError);
    expect(list.slice([0, 1]), [0, 1]);
    expect(list.slice([0, 2]), [0, 2]);
    expect(() => list.slice([2, 3]), throwsRangeError);
  });

  group('Sort', () {
    test('sorted', () {
      expect(reversedList.sorted, [0, 1, 2]);
    });

    test('sortedDescending', () {
      expect(list.sortedDescending, [2, 1, 0]);
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
