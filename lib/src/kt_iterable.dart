part of ktc_dart;

extension NumIterable on Iterable<num> {
  /// Returns an average value of elements in the collection.
  double get average =>
      cast<num>().reduce((value, element) => value + element) / length;
}

extension DeepIterable<E> on Iterable<Iterable<E>> {
  /// Returns a single [Iterable] of all elements from all [Iterable]s in the
  /// the [Iterable].
  Iterable<E> get flatten => expand((element) => element);
}

extension ComparableIteratable<E extends Comparable> on Iterable<E> {
  /// Returns the largest element or `null` if there are no elements.
  E? get maxOrNull {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var maxElement = iterator.current;
    for (final element in skip(1)) {
      if (maxElement.compareTo(element) < 0) maxElement = element;
    }

    return maxElement;
  }

  /// Returns the smallest element or `null` if there are no elements.
  E? get minOrNull {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var minElement = iterator.current;
    for (final element in skip(1)) {
      if (minElement.compareTo(element) > 0) minElement = element;
    }

    return minElement;
  }
}

extension NullableIterator<E> on Iterable<E?> {
  /// Returns an [Iterable] containing all elements that are not `null`.
  Iterable<E> whereNotNull() =>
      whereNot((element) => element == null).cast<E>();

  /// Returns an original collection containing all the non-null elements,
  /// throwing an [ArgumentError] if there are any null elements.
  Iterable<E> get requireNoNulls {
    for (final element in this) {
      if (element == null) throw ArgumentError.notNull('element');
    }

    return cast<E>();
  }
}

extension KtcIterable<E> on Iterable<E> {
  /// Returns a [Map] containing [MapEntry]s provided by [transform] function
  /// applied to elements of the given collection.
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(E element) transfrom) =>
      Map.fromEntries(map(transfrom));

  /// Returns a [Map] containing the elements from the given collection indexed
  /// by the key returned from [keySelector] function applied to each element.
  Map<K, E> associateBy<K>(K Function(E element) keySelector) =>
      Map.fromIterables(map(keySelector), this);

  /// Returns a [Map] containing the values provided by [valueTransform] and
  /// indexed by [keySelector] functions applied to elements of the given
  /// collection.
  Map<K, V> associateAndTransformBy<K, V>(
    K Function(E element) keySelector,
    V Function(E element) valueTransform,
  ) =>
      Map.fromIterables(map(keySelector), map(valueTransform));

  /// Returns a [Map] where keys are elements from the given collection and
  /// values are produced by the [valueSelector] function applied to each
  /// element.
  Map<E, V> associateWith<V>(V Function(E element) valueSelector) =>
      Map.fromIterables(this, map(valueSelector));

  /// Splits this collection into a [Iterable] of iterables each not exceeding
  /// the given [size].
  ///
  /// The last [Iterable] in the resulting [Iterable] may have fewer elements
  /// than the given [size].
  Iterable<Iterable<E>> chunked(int size) => Iterable.generate(
        length.isEven ? length ~/ size : length ~/ size + 1,
        (index) => skip(index * size).take(size),
      );

  /// Splits this collection into several iterables each not exceeding the given
  /// [size] and applies the given [transform] function to an each.
  Iterable<T> chunkedAndTransform<T>(
    int size,
    T Function(Iterable<E> chunk) transmform,
  ) =>
      chunked(size).map(transmform);

  /// Returns the number of elements matching the given [test].
  /// If [test] is not provided it returns the number of elements in the
  /// [Iterable].
  int count([bool Function(E element)? test]) =>
      test == null ? length : where(test).length;

  /// Returns a [Iterable] containing only distinct elements from the given
  /// collection.
  Iterable<E> get distinct {
    final set = <E>{};
    return where((element) => set.add(element));
  }

  /// Returns a [Iterable] containing only elements from the given collection
  /// having distinct keys returned by the given [selector] function.
  Iterable<E> distinctBy<K>(K Function(E element) selector) {
    final set = <K>{};
    return where((element) => set.add(selector(element)));
  }

  /// Returns an element at the given [index] or the result of calling the
  /// [defaultValue] function if the [index] is out of bounds of this
  /// collection.
  E elementAtOrElse(int index, E Function(int index) defaultValue) {
    if (length <= index || index < 0) return defaultValue(index);

    final iterator = this.iterator;
    var elementIndex = 0;

    while (iterator.moveNext()) {
      if (index == elementIndex) break;
      elementIndex++;
    }

    return iterator.current;
  }

  /// Returns an element at the given [index] or `null` if the [index] is out of
  /// bounds of this collection.
  E? elementAtOrNull(int index) {
    if (length <= index || index < 0) return null;

    final iterator = this.iterator;
    var elementIndex = 0;

    while (iterator.moveNext()) {
      if (index == elementIndex) break;
      elementIndex++;
    }

    return iterator.current;
  }

  /// Returns a single [Iterable] of all elements yielded from results of
  /// [transform] function being invoked on each element and its index in the
  /// original collection.
  Iterable<T> expandIndexed<T>(
    Iterable<T> Function(int index, E element) transform,
  ) {
    var index = 0;
    return expand((element) => transform(index++, element));
  }

  /// Returns the first non-null value produced by [transform] function being
  /// applied to elements of this collection in iteration order, or throws
  /// [NoSuchElementException] if no non-null value was produced.
  T firstNotNullOf<T>(T? Function(E element) transform) {
    for (final element in this) {
      final transformed = transform(element);

      if (transformed != null) return transformed;
    }

    throw NoSuchElementException();
  }

  /// Returns the first non-null value produced by [transform] function being
  /// applied to elements of this collection in iteration order, or `null` if
  /// no non-null value was produced.
  T? firstNotNullOfOrNull<T>(T? Function(E element) transform) {
    for (final element in this) {
      final transformed = transform(element);

      if (transformed != null) return transformed;
    }

    return null;
  }

  /// Returns the first element, or `null` if the collection is empty.
  /// If [test] is provided it returns the first element matching the given
  /// [test], or `null` if element was not found.
  E? firstOrNull([bool Function(E element)? test]) => isEmpty
      ? null
      : test == null
          ? first
          : firstWhereOrNull(test);

  /// Returns the first element matching the given [test], or `null` if no such
  /// element was found.
  E? firstWhereOrNull(bool Function(E element) test) {
    final iterator = this.iterator;

    while (iterator.moveNext()) {
      if (test(iterator.current)) return iterator.current;
    }

    return null;
  }

  /// Accumulates value starting with [initialValue] and applying operation from
  /// left to right to current accumulator value and each element with its index
  /// in the original collection.
  T foldIndexed<T>(
    T initialValue,
    T Function(int index, T previousValue, E element) combine,
  ) {
    var index = 0;
    return fold(
      initialValue,
      (previousValue, element) => combine(index++, previousValue, element),
    );
  }

  /// Performs the given [action] on each element, providing sequential index
  /// with the element.
  void forEachIndexed(void Function(int index, E element) action) {
    var index = 0;
    forEach((element) => action(index++, element));
  }

  /// Groups elements of the original collection by the key returned by the
  /// given [keySelector] function applied to each element and returns a [Map]
  /// where each group key is associated with a [Iterable] of corresponding
  /// elements.
  Map<K, Iterable<E>> groupBy<K>(K Function(E element) keySelector) {
    final groups = <K, Iterable<E>>{};

    for (final element in this) {
      final key = keySelector(element);

      groups.putIfAbsent(
          key, () => where((element) => keySelector(element) == key));
    }

    return groups;
  }

  /// Groups values returned by the [valueTransform] function applied to each
  /// element of the original collection by the key returned by the given
  /// [keySelector] function applied to the element and returns a [Map] where
  /// each group key is associated with a [Iterable] of corresponding values.
  Map<K, Iterable<V>> groupAndTransformBy<K, V>(
    K Function(E element) keySelector,
    V Function(E element) valueTransform,
  ) {
    final groups = <K, Iterable<V>>{};

    for (final element in this) {
      final key = keySelector(element);

      groups.putIfAbsent(
        key,
        () => where((element) => keySelector(element) == key)
            .map((element) => valueTransform(element)),
      );
    }

    return groups;
  }

  /// Returns first index of [element], or `-1` if the collection does not
  /// contain element.
  int indexOf(E element) {
    var index = 0;

    for (final e in this) {
      if (e == element) return index;
      index++;
    }

    return -1;
  }

  /// Returns index of the first element matching the given [test], or `-1` if
  /// the collection does not contain such element.
  int indexOfFirst(bool Function(E element) test) {
    var index = 0;

    for (final element in this) {
      if (test(element)) return index;
      index++;
    }

    return -1;
  }

  /// Returns index of the last element matching the given [test], or `-1` if
  /// the collection does not contain such element.
  int indexOfLast(bool Function(E element) test) {
    var lastIndex = -1;
    var index = 0;

    for (final element in this) {
      if (test(element)) lastIndex = index;
      index++;
    }

    return lastIndex;
  }

  /// Returns a [Iterable] containing all elements that are contained by both this
  /// collection and the specified collection.
  Iterable<E> intersect(Iterable<E> other) =>
      distinct.where((element) => other.contains(element));

  /// Appends the [String] from all the elements separated using [separator] and
  /// using the given [prefix] and [postfix] if supplied.
  S joinTo<S extends StringSink>({
    required S buffer,
    Object separator = ', ',
    Object prefix = '',
    Object postfix = '',
    int limit = -1,
    Object truncated = '...',
    Object Function(E element)? transform,
  }) {
    buffer.write(prefix);
    var count = 0;
    for (final element in this) {
      if (++count > 1) buffer.write(separator);
      if (limit < 0 || count <= limit) {
        buffer.write(transform?.call(element) ?? element);
      } else {
        break;
      }
    }
    if (limit >= 0 && count > limit) buffer.write(truncated);
    buffer.write(postfix);
    return buffer;
  }

  /// Creates a [String] from all the elements separated using [separator] and
  /// using the given [prefix] and [postfix] if supplied.
  String joinToString({
    Object separator = ', ',
    Object prefix = '',
    Object postfix = '',
    int limit = -1,
    Object truncated = '...',
    Object Function(E element)? transform,
  }) =>
      joinTo<StringBuffer>(
        buffer: StringBuffer(),
        separator: separator,
        prefix: prefix,
        postfix: postfix,
        limit: limit,
        truncated: truncated,
        transform: transform,
      ).toString();

  /// Returns last index of [element], or `-1` if the collection does not
  /// contain element.
  int lastIndexOf(E element) {
    if (!contains(element)) return -1;

    var lastIndex = -1;
    var index = 0;

    for (final elm in this) {
      if (element == elm) lastIndex = index;
      index++;
    }

    return lastIndex;
  }

  /// Returns the last element, or `null` if the collection is empty.
  /// If [test] is provided it returns the last element matching the given
  /// [test], or `null` if no such element was found.
  E? lastOrNull([bool Function(E element)? test]) => isEmpty
      ? null
      : test == null
          ? last
          : lastWhereOrNull(test);

  /// Returns the last element matching the given [test], or `null` if no such
  /// element was found.
  E? lastWhereOrNull(bool Function(E element) test) {
    final iterator = this.iterator;
    E? element;

    while (iterator.moveNext()) {
      if (test(iterator.current)) element = iterator.current;
    }

    return element;
  }

  /// Returns an [Iterable] containing the results of applying the given
  /// [transform] function to each element and its index in the original
  /// collection.
  Iterable<R> mapIndexed<R>(R Function(int index, E element) transform) {
    final iterator = this.iterator;

    return Iterable.generate(
      length,
      (index) => transform(index, (iterator..moveNext()).current),
    );
  }

  /// Returns an [Iterable] containing only the non-null results of applying the
  /// given transform function to each element and its index in the original
  /// collection.
  Iterable<R> mapIndexedNotNull<R>(
    R? Function(int index, E element) transform,
  ) {
    var index = 0;

    return map((element) => transform(index++, element)).whereNotNull();
  }

  /// Returns an [Iterable] containing only the non-null results of applying the
  /// given [transform] function to each element in the original collection.
  Iterable<R> mapNotNull<R>(R? Function(E element) transform) =>
      map(transform).whereNotNull();

  /// Returns the first element yielding the largest value of the given
  /// [selector] or null if there are no elements.
  E? maxByOrNull<R extends Comparable>(R Function(E element) selector) {
    if (isEmpty) return null;
    if (length == 1) return first;

    final iterator = this.iterator..moveNext();
    E maxElement = iterator.current;
    R maxValue = selector(maxElement);

    while (iterator.moveNext()) {
      final current = iterator.current;
      final value = selector(current);

      if (maxValue.compareTo(value) < 0) {
        maxElement = current;
        maxValue = value;
      }
    }

    return maxElement;
  }

  /// Returns the largest value among all values produced by [selector] function
  /// applied to each element in the collection.
  R maxOf<R extends Comparable>(R Function(E element) selector) {
    if (isEmpty) throw NoSuchElementException();

    final iterator = this.iterator..moveNext();
    var maxValue = selector(iterator.current);
    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (maxValue.compareTo(value) < 0) maxValue = value;
    }

    return maxValue;
  }

  /// Returns the largest value among all values produced by [selector] function
  /// applied to each element in the collection or `null` if there are no
  /// elements.
  R? maxOfOrNull<R extends Comparable>(R Function(E element) selector) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var maxValue = selector(iterator.current);
    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (maxValue.compareTo(value) < 0) maxValue = value;
    }

    return maxValue;
  }

  /// Returns the largest value according to the provided [comparator] among all
  /// values produced by [selector] function applied to each element in the
  /// collection.
  R maxOfWith<R>(Comparator<R> comparator, R Function(E element) selector) {
    if (isEmpty) throw NoSuchElementException();

    final iterator = this.iterator..moveNext();
    var maxValue = selector(iterator.current);
    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (comparator(maxValue, value) < 0) maxValue = value;
    }

    return maxValue;
  }

  /// Returns the largest value according to the provided [comparator] among all
  /// values produced by [selector] function applied to each element in the
  /// collection or `null` if there are no elements.
  R? maxOfWithOrNull<R>(
    Comparator<R> comparator,
    R Function(E element) selector,
  ) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var maxValue = selector(iterator.current);

    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (comparator(maxValue, value) < 0) maxValue = value;
    }

    return maxValue;
  }

  /// Returns the first element having the largest value according to the
  /// provided [comparator] or null if there are no elements.
  E? maxWithOrNull(Comparator<E> comparator) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var maxElement = iterator.current;

    for (final element in skip(1)) {
      if (comparator(maxElement, element) < 0) maxElement = element;
    }

    return maxElement;
  }

  /// Returns the first element yielding the smallest value of the given
  /// [selector] function or `null` if there are no elements.
  E? minByOrNull<R extends Comparable>(R Function(E element) selector) {
    if (isEmpty) return null;
    if (length == 1) return first;

    final iterator = this.iterator..moveNext();
    E minElement = iterator.current;
    R minValue = selector(minElement);

    while (iterator.moveNext()) {
      final current = iterator.current;
      final value = selector(current);

      if (minValue.compareTo(value) > 0) {
        minElement = current;
        minValue = value;
      }
    }

    return minElement;
  }

  /// Returns the smallest value among all values produced by [selector]
  /// function applied to each element in the collection.
  R minOf<R extends Comparable>(R Function(E element) selector) {
    if (isEmpty) throw NoSuchElementException();

    final iterator = this.iterator..moveNext();
    var minValue = selector(iterator.current);
    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (minValue.compareTo(value) > 0) minValue = value;
    }

    return minValue;
  }

  /// Returns the smallest value among all values produced by [selector]
  /// function applied to each element in the collection or `null` if there are
  /// no elements.
  R? minOfOrNull<R extends Comparable>(R Function(E element) selector) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var minValue = selector(iterator.current);
    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (minValue.compareTo(value) > 0) minValue = value;
    }

    return minValue;
  }

  /// Returns the smallest value according to the provided [comparator] among
  /// all values produced by [selector] function applied to each element in the
  /// collection.
  R minOfWith<R>(Comparator<R> comparator, R Function(E element) selector) {
    if (isEmpty) throw NoSuchElementException();

    final iterator = this.iterator..moveNext();
    var minValue = selector(iterator.current);
    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (comparator(minValue, value) > 0) minValue = value;
    }

    return minValue;
  }

  /// Returns the smallest value according to the provided [comparator] among
  /// all values produced by [selector] function applied to each element in the
  /// collection or `null` if there are no elements.
  R? minOfWithOrNull<R>(
    Comparator<R> comparator,
    R Function(E element) selector,
  ) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var minValue = selector(iterator.current);

    while (iterator.moveNext()) {
      final value = selector(iterator.current);

      if (comparator(minValue, value) > 0) minValue = value;
    }

    return minValue;
  }

  /// Returns the first element having the smallest value according to the
  /// provided [comparator] or `null` if there are no elements.
  E? minWithOrNull(Comparator<E> comparator) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    var minElement = iterator.current;

    for (final element in skip(1)) {
      if (comparator(minElement, element) > 0) minElement = element;
    }

    return minElement;
  }

  /// Returns true if the collection has no elements.
  ///
  /// If [test] is provided it returns true if no elements match the given
  /// [test].
  bool none([bool Function(E element)? test]) =>
      test == null ? isEmpty : !any(test);

  /// Performs the given [action] on each element and returns the collection
  /// itself afterwards.
  Iterable<E> onEach(void Function(E element) action) {
    for (final element in this) {
      action(element);
    }

    return this;
  }

  /// Performs the given [action] on each element, providing sequential index
  /// with the element, and returns the collection itself afterwards.
  Iterable<E> onEachIndexed(void Function(int index, E element) action) {
    var index = 0;

    for (final element in this) {
      action(index++, element);
    }

    return this;
  }

  /// Splits the original collection into [Pair] of iterables, where first
  /// [Iterable] contains elements for which [test] yielded true, while second
  /// [Iterable] contains elements for which [test] yielded false.
  Pair<Iterable<E>, Iterable<E>> partition(bool Function(E element) test) =>
      Pair(where(test), whereNot(test));

  /// Accumulates value starting with the first element and applying [combine]
  /// function from left to right to current accumulator value and each element
  /// with its index in the original collection.
  E reduceIndexed(E Function(int index, E value, E element) combine) {
    if (isEmpty) throw NoSuchElementException();

    final iterator = this.iterator..moveNext();
    int index = 1;
    E value = iterator.current;

    while (iterator.moveNext()) {
      value = combine(index++, value, iterator.current);
    }

    return value;
  }

  /// Accumulates value starting with the first element and applying [combine]
  /// function from left to right to current accumulator value and each element
  /// with its index in the original collection.
  E? reduceIndexedOrNull(E Function(int index, E value, E element) combine) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    int index = 1;
    E value = iterator.current;

    while (iterator.moveNext()) {
      value = combine(index++, value, iterator.current);
    }

    return value;
  }

  /// Accumulates value starting with the first element and applying [combine]
  /// function from left to right to current accumulator value and each element.
  E? reduceOrNull(E Function(E value, E element) combine) {
    if (isEmpty) return null;

    final iterator = this.iterator..moveNext();
    E value = iterator.current;

    while (iterator.moveNext()) {
      value = combine(value, iterator.current);
    }

    return value;
  }

  /// Returns a [Iterable] with elements in reversed order.
  Iterable<E> get reversed => Iterable.generate(
        length,
        (index) => elementAt(length - index - 1),
      );

  /// Returns a [Iterable] containing successive accumulation values generated
  /// by applying [combine] function from left to right to each element and
  /// current accumulator value that starts with [initialValue].
  Iterable<R> runningFold<R>(
    R initialValue,
    R Function(R previousValue, E element) combine,
  ) {
    var previousValue = initialValue;

    return [initialValue].followedBy(map((element) {
      previousValue = combine(previousValue, element);
      return previousValue;
    }));
  }

  /// Returns a [Iterable] containing successive accumulation values generated
  /// by applying [combine] function from left to right to each element and
  /// current accumulator value that starts with [initialValue].
  Iterable<R> runningFoldIndexed<R>(
    R initialValue,
    R Function(int index, R previousValue, E element) combine,
  ) {
    var previousValue = initialValue;
    var index = 0;

    return [initialValue].followedBy(map((element) {
      previousValue = combine(index++, previousValue, element);
      return previousValue;
    }));
  }

  /// Returns a [Iterable] containing successive accumulation values generated
  /// by applying [combine] function from left to right to each element and
  /// current accumulator value that starts with the first element of this
  /// collection.
  Iterable<E> runningReduce(E Function(E value, E element) combine) {
    if (isEmpty) return Iterable.empty();

    E value = first;

    return skip(1).map((element) {
      value = combine(value, element);
      return value;
    });
  }

  /// Returns a [Iterable] containing successive accumulation values generated
  /// by applying [combine] function from left to right to each element, its
  /// index in the original collection and current accumulator value that starts
  /// with the first element of this collection.
  Iterable<E> runningReduceIndexed(
    E Function(int index, E value, E element) combine,
  ) {
    if (isEmpty) return Iterable.empty();

    var index = 1;
    var value = first;

    return skip(1).map((element) {
      value = combine(index++, value, element);
      return value;
    });
  }

  /// Returns a new [List] with the elements of this list randomly shuffled
  /// using the specified [random] instance as the source of randomness.
  List<E> shuffled([Random? random]) => toList()..shuffle();

  /// Returns single element, or `null` if the collection is empty or has more
  /// than one element.
  E? singleOrNull() => length != 1 ? null : single;

  /// Returns the single element matching the given [test], or `null` if element
  /// was not found or more than one element was found.
  E? singleWhereOrNull(bool Function(E element) test) {
    var found = false;
    E? single;

    for (final element in this) {
      if (test(element)) {
        if (found) return null;
        single = element;
        found = true;
      }
    }

    return single;
  }

  /// Returns a [Iterable] containing only elements matching the given [test].
  Iterable<E> whereIndexed(bool Function(int index, E element) test) {
    var index = 0;
    return where((element) => test(index++, element));
  }

  /// Returns an [Iterable] containing all elements that are instances of
  /// specified type parameter [T].
  Iterable<T> whereIsInstance<T>() =>
      where((element) => element is T).cast<T>();

  /// Returns an [Iterable] containing all elements not matching the given [test].
  Iterable<E> whereNot(bool Function(E element) test) =>
      where((element) => !test(element));

  /// Returns an [Iterable] containing all elements of the original collection
  /// except the elements contained in the [other] collection.
  Iterable<E> operator -(Iterable<E> other) => whereNot(other.contains);

  /// Returns an [Iterable] containing all elements of the original collection
  /// and then all elements of the [other] collection.
  Iterable<E> operator +(Iterable<E> other) => followedBy(other);

  /// Returns an [Iterable] that has been removed by the number of [count] from
  /// the beginning.
  ///
  /// If [count] is negative it `throws` [ArgumentError].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  Iterable<E> operator <<(int count) => count.isNegative
      ? throw ArgumentError.value(count, 'count', 'Cannot be negative')
      : skip(count);

  /// Returns an [Iterable] that has been removed by the number of [count] from
  /// the end.
  ///
  /// If [count] is negative it `throws` [ArgumentError].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  Iterable<E> operator >>(int count) => count.isNegative
      ? throw ArgumentError.value(count, 'count', 'Cannot be negative')
      : take(length - count);
}
