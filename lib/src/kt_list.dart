import 'dart:math';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'kt_exceptions.dart';
import 'kt_iterable.dart';

@visibleForTesting
void rangeCheck({
  required int length,
  required int fromIndex,
  required int toIndex,
}) {
  if (fromIndex > toIndex) {
    throw ArgumentError.value(
      fromIndex,
      'fromIndex',
      'greater than toIndex ($toIndex).',
    );
  }
  if (fromIndex < 0) {
    throw RangeError.value(fromIndex, 'fromIndex', 'less than zero.');
  }
  if (toIndex > length) {
    throw RangeError.value(
      toIndex,
      'toIndex',
      'greater than size ($length).',
    );
  }
}

extension ComparableList<E extends Comparable> on List<E> {
  /// Searches this [List] or its range for the provided element using the
  /// binary search algorithm. The [List] is expected to be sorted into
  /// ascending order according to the [Comparable] natural ordering of its
  /// elements, otherwise the result is undefined.
  int binarySearch({
    E? element,
    int? fromIndex,
    int? toIndex,
  }) {
    fromIndex ??= 0;
    toIndex ??= length;

    rangeCheck(length: length, fromIndex: fromIndex, toIndex: toIndex);

    var low = fromIndex;
    var high = toIndex - 1;

    while (low <= high) {
      // todo: Change to `>>>` operator
      // Change when stable `Dart` SDK version becomes to 2.14.0 over.
      final mid = (low + high) ~/ 2;
      final midVal = this[mid];
      final cmp = element == null ? 1 : midVal.compareTo(element);

      if (cmp < 0) {
        low = mid + 1;
      } else if (cmp > 0) {
        high = mid - 1;
      } else {
        return mid;
      }
    }

    return -(low + 1);
  }

  /// Returns a [List] of all elements sorted according to their natural sort
  /// order.
  List<E> get sorted => toList()..sort();

  /// Returns a [List] of all elements sorted descending according to their
  /// natural sort order.
  List<E> get sortedDescending => toList()..sort((a, b) => b.compareTo(a));
}

extension KtcList<E> on List<E> {
  /// Searches this [List] or its range for an element having the key returned
  /// by the specified selector function equal to the provided key value using
  /// the binary search algorithm. The [List] is expected to be sorted into
  /// ascending order according to the Comparable natural ordering of keys of
  /// its elements. otherwise the result is undefined.
  int binarySearchBy<K extends Comparable?>({
    required K? Function(E element) selector,
    K? key,
    int? fromIndex,
    int? toIndex,
  }) =>
      binarySearchWithComparison(
        comparison: (element) =>
            key == null ? 1 : selector(element)?.compareTo(key) ?? -1,
        fromIndex: fromIndex,
        toIndex: toIndex,
      );

  /// Searches this [List] or its range for the provided element using the
  /// binary search algorithm. The [List] is expected to be sorted into
  /// ascending order according to the specified comparator, otherwise the
  /// result is undefined.
  int binarySearchWithComparator({
    required E element,
    required Comparator<E> comparator,
    int? fromIndex,
    int? toIndex,
  }) {
    fromIndex ??= 0;
    toIndex ??= length;

    rangeCheck(length: length, fromIndex: fromIndex, toIndex: toIndex);

    var low = fromIndex;
    var high = toIndex - 1;

    while (low <= high) {
      // todo: Change to `>>>` operator
      // Change when stable `Dart` SDK version becomes to 2.14.0 over.
      final mid = (low + high) ~/ 2;
      final midVal = this[mid];
      final cmp = comparator(midVal, element);

      if (cmp < 0) {
        low = mid + 1;
      } else if (cmp > 0) {
        high = mid - 1;
      } else {
        return mid;
      }
    }

    return -(low + 1);
  }

  /// Searches this [List] or its range for an element for which the given
  /// comparison function returns zero using the binary search algorithm.
  int binarySearchWithComparison({
    required int Function(E element) comparison,
    int? fromIndex,
    int? toIndex,
  }) {
    fromIndex ??= 0;
    toIndex ??= length;

    rangeCheck(length: length, fromIndex: fromIndex, toIndex: toIndex);

    var low = fromIndex;
    var high = toIndex - 1;

    while (low <= high) {
      // todo: Change to `>>>` operator
      // Change when stable `Dart` SDK version becomes to 2.14.0 over.
      final mid = (low + high) ~/ 2;
      final midVal = this[mid];
      final cmp = comparison(midVal);

      if (cmp < 0) {
        low = mid + 1;
      } else if (cmp > 0) {
        high = mid - 1;
      } else {
        return mid;
      }
    }

    return -(low + 1);
  }

  /// Checks if all elements in the specified collection are contained in this
  /// collection.
  bool containsAll(Iterable<E> other) {
    var result = true;

    for (final element in other) {
      result &= contains(element);
    }

    return result;
  }

  /// Returns a [List] containing all elements except last [count] elements.
  List<E> dropLast(int count) {
    if (count.isNegative) {
      throw ArgumentError.value(
        count,
        'count',
        'Must be greater than zero',
      );
    }

    final length = this.length - count;

    return length.isNegative ? [] : sublist(0, length);
  }

  /// Returns a [List] containing all elements except first elements that
  /// satisfy the given [test].
  List<E> dropLastWhile(bool Function(E element) test) {
    var count = 0;

    for (final element in reversed) {
      if (!test(element)) break;

      count++;
    }

    return dropLast(count);
  }

  /// Accumulates value starting with [initialValue] and applying [combine]
  /// function from right to left to each element and current accumulator value.
  R foldRight<R>(
    R initialValue,
    R Function(R previousValue, E element) combine,
  ) =>
      reversed.fold(initialValue, combine);

  /// Accumulates value starting with [initialValue] and applying [combine]
  /// function from right to left to each element with its index in the original
  /// [List] and current accumulator value.
  R foldRightIndexed<R>(
    R initialValue,
    R Function(int index, R previousValue, E element) combine,
  ) {
    var index = length - 1;

    return reversed.fold(
      initialValue,
      (previousValue, element) => combine(index--, previousValue, element),
    );
  }

  /// Returns the index of the last item in the [List] or -1 if the [List] is
  /// empty.
  int get lastIndex => length - 1;

  /// Returns a random element from this collection using the specified source
  /// of randomness.
  E random([Random? random]) {
    if (isEmpty) throw NoSuchElementException('Collection is empty.');

    random ??= Random();

    return this[random.nextInt(length - 1)];
  }

  /// Returns a random element from this collection using the specified source
  /// of randomness, or null if this collection is empty.
  E? randomOrNull([Random? random]) => isEmpty ? null : this.random(random);

  /// Returns a new [List] with the elements of this [List] randomly shuffled
  /// using the specified [random] instance as the source of randomness.
  List<E> shuffled([Random? random]) => toList()..shuffle();

  /// Returns a [List] containing elements at specified [indices].
  List<E> slice(Iterable<int> indices) {
    final list = <E>[];

    for (final index in indices) {
      list.add(this[index]);
    }

    return list;
  }

  /// Returns an [List] containing all elements of the original collection
  /// except the elements contained in the [other] collection.
  List<E> operator -(Iterable<E> other) => whereNot(other.contains).toList();

  /// Returns an [List] containing all elements of the original collection and
  /// then all elements of the [other] collection.
  List<E> operator +(Iterable<E> other) => [...this, ...other];

  /// Returns an [List] that has been removed by the number of [count] from the
  /// beginning.
  ///
  /// If [count] is negative it `throws` [ArgumentError].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  List<E> operator <<(int count) => count.isNegative
      ? throw ArgumentError.value(count, 'count', 'Cannot be negative')
      : count > length
          ? []
          : sublist(count);

  /// Returns an [List] that has been removed by the number of [count] from the
  /// end.
  ///
  /// If [count] is negative it `throws` [ArgumentError].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  List<E> operator >>(int count) => count.isNegative
      ? throw ArgumentError.value(count, 'count', 'Cannot be negative')
      : count > length
          ? []
          : sublist(0, length - count);

  /// Returns a [List] containing all elements that are contained by both this
  /// collection and the specified collection.
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  List<E> operator &(Iterable<E> other) => intersect(other).toList();

  /// Returns a [List] containing all [distinct] elements from both collections.
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  List<E> operator |(Iterable<E> other) => union(other).toList();

  /// Returns a [List] containing all elements from both collections without
  /// [intersect].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  List<E> operator ^(Iterable<E> other) => (this - other) | (other - this);
}
