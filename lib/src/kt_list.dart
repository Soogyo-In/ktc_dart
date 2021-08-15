part of ktc_dart;

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

extension DeepList<E> on List<List<E>> {
  /// Returns a single [List] of all elements from all [List]s in the [List].
  List<E> get flatten {
    final expanded = <E>[];

    for (final element in this) {
      expanded.addAll(element);
    }

    return expanded;
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
  List<E> get sorted => this..sort();

  /// Returns a [List] of all elements sorted descending according to their
  /// natural sort order.
  List<E> get sortedDescending => this..sort((a, b) => b.compareTo(a));
}

extension NullableList<E> on List<E?> {
  /// Returns an [List] containing all elements that are not `null`.
  List<E> get whereNotNull {
    final list = <E>[];

    for (final element in this) {
      if (element != null) list.add(element);
    }

    return list;
  }

  /// Returns an original collection containing all the non-null elements,
  /// throwing an [ArgumentError] if there are any null elements.
  List<E> get requireNoNulls {
    final list = <E>[];

    for (final element in this) {
      if (element == null) throw ArgumentError.notNull('element');

      list.add(element);
    }

    return list;
  }
}

extension PairList<E1, E2> on List<Pair<E1, E2>> {
  /// Returns a [Pair] of iterables, where first [List] is built from the first
  /// values of each [Pair] from this collection, second [List] is built from
  /// the second values of each [Pair] from this collection.
  Pair<List<E1>, List<E2>> unzip() {
    final list1 = <E1>[];
    final list2 = <E2>[];

    for (final element in this) {
      list1.add(element.first);
      list2.add(element.second);
    }

    return Pair(list1, list2);
  }
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

  /// Splits this collection into a [List] of iterables each not exceeding the
  /// given [size].
  ///
  /// The last [List] in the resulting [List] may have fewer elements than the
  /// given [size].
  List<List<E>> chunked(int size) =>
      windowed(size: size, step: size, partialWindows: true);

  /// Splits this collection into several iterables each not exceeding the given
  /// [size] and applies the given [transform] function to an each.
  Iterable<T> chunkedAndTransform<T>(
    int size,
    T Function(Iterable<E> chunk) transform,
  ) =>
      windowedAndTransform<T>(
        size: size,
        step: size,
        transform: transform,
        partialWindows: true,
      );

  /// Checks if all elements in the specified collection are contained in this
  /// collection.
  bool containsAll(Iterable<E> other) {
    var result = true;

    for (final element in other) {
      result &= contains(element);
    }

    return result;
  }

  /// Returns the number of elements matching the given [test].
  /// If [test] is not provided it returns the number of elements in the [List].
  int count([bool Function(E element)? test]) {
    var count = 0;

    for (final element in this) {
      if (test?.call(element) ?? true) count++;
    }

    return count;
  }

  /// Returns a [List] containing only distinct elements from the given
  /// collection.
  List<E> get distinct => toSet().toList();

  /// Returns a [List] containing only elements from the given collection having
  /// distinct keys returned by the given [selector] function.
  List<E> distinctBy<K>(K Function(E element) selector) {
    final set = <K>{};
    final list = <E>[];

    for (final element in this) {
      if (set.add(selector(element))) list.add(element);
    }

    return list;
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

  /// Returns a single [List] of all elements yielded from results of
  /// [transform] function being invoked on each element and its index in the
  /// original collection.
  List<T> expandIndexed<T>(
    Iterable<T> Function(int index, E element) transform,
  ) {
    final list = <T>[];
    var index = 0;

    for (final element in this) {
      list.addAll(transform(index++, element));
    }

    return list;
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

  /// Groups elements of the original collection by the key returned by the
  /// given [keySelector] function applied to each element and returns a [Map]
  /// where each group key is associated with a [List] of corresponding
  /// elements.
  Map<K, List<E>> groupBy<K>(K Function(E element) keySelector) {
    final groups = <K, List<E>>{};

    for (final element in this) {
      final key = keySelector(element);
      final group = groups[key];

      if (group == null) {
        groups[key] = [element];
      } else {
        group.add(element);
      }
    }

    return groups;
  }

  /// Groups values returned by the [valueTransform] function applied to each
  /// element of the original collection by the key returned by the given
  /// [keySelector] function applied to the element and returns a [Map] where
  /// each group key is associated with a [List] of corresponding values.
  Map<K, List<V>> groupAndTransformBy<K, V>(
    K Function(E element) keySelector,
    V Function(E element) valueTransform,
  ) {
    final groups = <K, List<V>>{};

    for (final element in this) {
      final key = keySelector(element);
      final value = valueTransform(element);
      final group = groups[key];

      if (group == null) {
        groups[key] = [value];
      } else {
        group.add(value);
      }
    }

    return groups;
  }

  /// Returns an [Iterable] of the valid indices for this collection.
  Iterable<int> get indices => Iterable<int>.generate(length);

  /// Returns a [List] containing all elements that are contained by both this
  /// collection and the specified collection.
  List<E> intersect(Iterable<E> other) {
    final list = <E>[];

    for (final element in distinct) {
      if (other.contains(element)) list.add(element);
    }

    return list;
  }

  /// Returns the index of the last item in the list or -1 if the list is empty.
  int get lastIndex => length - 1;

  /// Returns an [List] containing the results of applying the given [transform]
  /// function to each element and its index in the original collection.
  List<R> mapIndexed<R>(R Function(int index, E element) transform) {
    final list = <R>[];
    var index = 0;

    for (final element in this) {
      list.add(transform(index++, element));
    }

    return list;
  }

  /// Returns an [List] containing only the non-null results of applying the
  /// given transform function to each element and its index in the original
  /// collection.
  List<R> mapIndexedNotNull<R>(
    R? Function(int index, E element) transform,
  ) {
    final list = <R>[];
    var index = 0;

    for (final element in this) {
      final value = transform(index++, element);

      if (value != null) list.add(value);
    }

    return list;
  }

  /// Returns an [List] containing only the non-null results of applying the
  /// given [transform] function to each element in the original collection.
  List<R> mapNotNull<R>(R? Function(E element) transform) {
    final list = <R>[];

    for (final element in this) {
      final value = transform(element);

      if (value != null) list.add(value);
    }

    return list;
  }

  /// Performs the given [action] on each element and returns the collection
  /// itself afterwards.
  List<E> onEach(void Function(E element) action) {
    for (final element in this) {
      action(element);
    }

    return this;
  }

  /// Performs the given [action] on each element, providing sequential index
  /// with the element, and returns the collection itself afterwards.
  List<E> onEachIndexed(void Function(int index, E element) action) {
    var index = 0;

    for (final element in this) {
      action(index++, element);
    }

    return this;
  }

  /// Splits the original collection into [Pair] of iterables, where first
  /// [List] contains elements for which [test] yielded true, while second
  /// [List] contains elements for which [test] yielded false.
  Pair<List<E>, List<E>> partition(bool Function(E element) test) {
    final list1 = <E>[];
    final list2 = <E>[];

    for (final element in this) {
      if (test(element)) {
        list1.add(element);
      } else {
        list2.add(element);
      }
    }

    return Pair(list1, list2);
  }

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

  /// Returns a [List] containing successive accumulation values generated by
  /// applying [combine] function from left to right to each element and current
  /// accumulator value that starts with [initialValue].
  List<R> runningFold<R>(
    R initialValue,
    R Function(R previousValue, E element) combine,
  ) {
    final list = <R>[initialValue];
    var previousValue = initialValue;

    for (final element in this) {
      previousValue = combine(previousValue, element);
      list.add(previousValue);
    }

    return list;
  }

  /// Returns a [List] containing successive accumulation values generated by
  /// applying [combine] function from left to right to each element and current
  /// accumulator value that starts with [initialValue].
  List<R> runningFoldIndexed<R>(
    R initialValue,
    R Function(int index, R previousValue, E element) combine,
  ) {
    final list = <R>[initialValue];
    var previousValue = initialValue;
    var index = 0;

    for (final element in this) {
      previousValue = combine(index++, previousValue, element);
      list.add(previousValue);
    }

    return list;
  }

  /// Returns a [List] containing successive accumulation values generated by
  /// applying [combine] function from left to right to each element and
  /// current accumulator value that starts with the first element of this
  /// collection.
  List<E> runningReduce(E Function(E value, E element) combine) {
    final list = <E>[];

    if (isNotEmpty) {
      final iterator = this.iterator..moveNext();
      E value = iterator.current;

      while (iterator.moveNext()) {
        value = combine(value, iterator.current);
        list.add(value);
      }
    }

    return list;
  }

  /// Returns a [List] containing successive accumulation values generated by
  /// applying [combine] function from left to right to each element, its index
  /// in the original collection and current accumulator value that starts
  /// with the first element of this collection.
  List<E> runningReduceIndexed(
    E Function(int index, E value, E element) combine,
  ) {
    final list = <E>[];

    if (isNotEmpty) {
      final iterator = this.iterator..moveNext();
      var index = 1;
      E value = iterator.current;

      while (iterator.moveNext()) {
        value = combine(index++, value, iterator.current);
        list.add(value);
      }
    }

    return list;
  }

  /// Returns a new [List] with the elements of this list randomly shuffled
  /// using the specified [random] instance as the source of randomness.
  List<E> shuffled([Random? random]) => this..shuffle();

  /// Returns a [List] containing elements at specified [indices].
  List<E> slice(Iterable<int> indices) {
    final list = <E>[];

    for (final index in indices) {
      list.add(this[index]);
    }

    return list;
  }

  /// Returns a [List] of all elements sorted according to the specified
  /// [comparator].
  List<E> sortedWith(Comparator<E> comparator) => this..sort(comparator);

  /// Returns a [List] containing all [distinct] elements from both collections.
  List<E> union(Iterable<E> other) => followedBy(other).distinct.toList();

  /// Returns a [List] containing only elements matching the given [test].
  List<E> whereIndexed(bool Function(int index, E element) test) {
    final list = <E>[];
    var index = 0;

    for (final element in this) {
      if (test(index++, element)) list.add(element);
    }

    return list;
  }

  /// Returns an [List] containing all elements that are instances of specified
  /// type parameter [T].
  List<T> whereIsInstance<T>() {
    final list = <T>[];

    for (final element in this) {
      if (element is T) list.add(element);
    }

    return list;
  }

  /// Returns an [List] containing all elements not matching the given [test].
  List<E> whereNot(bool Function(E element) test) {
    final list = <E>[];

    for (final element in this) {
      if (!test(element)) list.add(element);
    }

    return list;
  }

  /// Returns a [List] of snapshots of the window of the given [size]
  /// sliding along this collection with the given [step], where each snapshot
  /// is a [List].
  List<List<E>> windowed({
    required int size,
    int step = 1,
    bool partialWindows = false,
  }) {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be greater than zero');
    }

    if (step <= 0) {
      throw ArgumentError.value(step, 'step', 'must be greater than zero');
    }

    final chunks = <List<E>>[];
    var index = 0;

    for (final element in this) {
      if (index % step == 0) {
        if (partialWindows) {
          chunks.add([]);
        } else if (length - index >= size) {
          chunks.add([]);
        }
      }

      for (final chunk in chunks) {
        if (chunk.length < size) chunk.add(element);
      }

      index++;
    }

    return chunks;
  }

  /// Returns a [List] of results of applying the given [transform] function to
  /// an each [List] representing a view over the window of the given [size]
  /// sliding along this collection with the given [step].
  List<R> windowedAndTransform<R>({
    required int size,
    required R Function(Iterable<E> element) transform,
    int step = 1,
    bool partialWindows = false,
  }) {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be greater than zero');
    }

    if (step <= 0) {
      throw ArgumentError.value(step, 'step', 'must be greater than zero');
    }

    final list = <R>[];

    for (final chunk in windowed(
      size: size,
      step: step,
      partialWindows: partialWindows,
    )) {
      list.add(transform(chunk));
    }

    return list;
  }

  /// Returns a lazy [List] that wraps each element of the original collection
  /// into an [IndexedValue] containing the index of that element and the
  /// element itself.
  List<IndexedValue<E>> get withIndex {
    final list = <IndexedValue<E>>[];
    var index = 0;

    for (final element in this) {
      list.add(IndexedValue(index++, element));
    }

    return list;
  }

  /// Returns a [List] of pairs built from the elements of this collection and
  /// [other] collection with the same index. The returned [List] has length of
  /// the shortest collection.
  List<Pair<E, T>> zip<T>(Iterable<T> other) {
    final iter1 = iterator;
    final iter2 = other.iterator;
    final list = <Pair<E, T>>[];

    while (iter1.moveNext() && iter2.moveNext()) {
      list.add(Pair(iter1.current, iter2.current));
    }

    return list;
  }

  /// Returns a [List] of values built from the elements of this collection and
  /// the [other] collection with the same index using the provided [transform]
  /// function applied to each pair of elements. The returned [List] has length
  /// of the shortest collection.
  List<R> zipAndTransform<T, R>(
    Iterable<T> other,
    R Function(Pair<E, T> pair) transform,
  ) {
    final iter1 = iterator;
    final iter2 = other.iterator;
    final list = <R>[];

    while (iter1.moveNext() && iter2.moveNext()) {
      list.add(transform(Pair(iter1.current, iter2.current)));
    }

    return list;
  }

  /// Returns a [List] of pairs of each two adjacent elements in this
  /// collection.
  List<Pair<E, E>> get zipWithNext {
    final list = <Pair<E, E>>[];

    for (var i = 1; i < length; i++) {
      list.add(Pair(this[i - 1], this[i]));
    }

    return list;
  }

  /// Returns a [List] containing the results of applying the given [transform]
  /// function to an each [Pair] of two adjacent elements in this collection.
  List<R> zipWithNextAndTransform<R>(
    R Function(Pair<E, E> pair) transform,
  ) {
    final list = <R>[];

    for (var i = 1; i < length; i++) {
      list.add(transform(Pair(this[i - 1], this[i])));
    }

    return list;
  }

  /// Returns an [List] containing all elements of the original collection
  /// except the elements contained in the [other] collection.
  List<E> operator -(Iterable<E> other) => whereNot(other.contains);

  /// Returns an [Iterable] containing all elements of the original collection
  /// and then all elements of the [other] collection.
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
  List<E> operator &(Iterable<E> other) => intersect(other);

  /// Returns a [List] containing all [distinct] elements from both collections.
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  List<E> operator |(Iterable<E> other) => union(other);

  /// Returns a [List] containing all elements from both collections without
  /// [intersect].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  List<E> operator ^(Iterable<E> other) => (this - other) | (other - this);
}
