part of ktc_dart;

extension NumIterable on Iterable<num> {
  /// Returns an average value of elements in the collection.
  double get average =>
      cast<num>().reduce((value, element) => value + element) / length;
}

extension KtcIterable<E> on Iterable<E> {
  /// Returns a [Map] containing [MapEntry]s provided by [transform] function applied to elements of the given collection.
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(E element) transfrom) =>
      Map.fromEntries(map(transfrom));

  /// Returns a [Map] containing the elements from the given collection indexed by the key returned from [keySelector] function applied to each element.
  Map<K, E> associateBy<K>(K Function(E element) keySelector) =>
      Map.fromIterables(map(keySelector), this);

  /// Returns a [Map] containing the values provided by [valueTransform] and indexed by [keySelector] functions applied to elements of the given collection.
  Map<K, V> associateAndTransformBy<K, V>(
    K Function(E element) keySelector,
    V Function(E element) valueTransform,
  ) =>
      Map.fromIterables(map(keySelector), map(valueTransform));

  /// Returns a [Map] where keys are elements from the given collection and values are produced by the [valueSelector] function applied to each element.
  Map<E, V> associateWith<V>(V Function(E element) valueSelector) =>
      Map.fromIterables(this, map(valueSelector));

  /// Splits this collection into a list of lists each not exceeding the given [size].
  ///
  /// The last list in the resulting list may have fewer elements than the given [size].
  List<List<E>> chunked(int size) => List.generate(
        length % size == 0 ? length ~/ size : length ~/ size + 1,
        (index) => skip(index * size).take(size).toList(),
      );

  /// Splits this collection into several lists each not exceeding the given [size] and applies the given [transform] function to an each.
  List<T> chunkedAndTransform<T>(
    int size,
    T Function(List<E> chunk) transmform,
  ) =>
      chunked(size).map(transmform).toList();

  /// Returns the number of elements matching the given [test].
  /// If [test] is not provided it returns the number of elements in the [Iterable].
  int count([bool Function(E element)? test]) =>
      test == null ? length : where(test).length;

  /// Returns a [List] containing only distinct elements from the given collection.
  List<E> get distinct => toSet().toList();

  /// Returns a [List] containing only elements from the given collection having distinct keys returned by the given [selector] function.
  List<E> distinctBy<K>(K Function(E element) selector) {
    final set = <K>{};
    final list = <E>[];

    for (final element in this) {
      final key = selector(element);

      if (set.add(key)) list.add(element);
    }

    return list;
  }

  /// Returns an element at the given [index] or the result of calling the [defaultValue] function if the [index] is out of bounds of this collection.
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

  /// Returns an element at the given [index] or `null` if the [index] is out of bounds of this collection.
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

  /// Returns the first element matching the given [test], or `null` if no such element was found.
  E? find(bool Function(E element) test) {
    final iterator = this.iterator;

    while (iterator.moveNext()) {
      if (test(iterator.current)) return iterator.current;
    }

    return null;
  }

  /// Returns the last element matching the given [test], or `null` if no such element was found.
  E? findLast(bool Function(E element) test) {
    final iterator = this.iterator;
    E? element;

    while (iterator.moveNext()) {
      if (test(iterator.current)) element = iterator.current;
    }

    return element;
  }

  /// Returns a [List] containing only elements matching the given [test].
  List<E> whereIndexed(bool Function(int index, E element) test) {
    final list = <E>[];
    var index = 0;

    for (final element in this) {
      if (test(index++, element)) list.add(element);
    }

    return list;
  }

  /// Returns a [Iterable] containing all elements that are instances of specified type parameter [T].
  Iterable<T> whereIsInstance<T>() =>
      where((element) => element is T).cast<T>();

  /// Returns a [Iterable] containing all elements not matching the given [test].
  Iterable<E> whereNot(bool Function(E element) test) =>
      where((element) => !test(element));

  /// Returns a [Iterable] containing all elements that are not `null`.
  Iterable<E> whereNotNull() => where((element) => element != null);
}
