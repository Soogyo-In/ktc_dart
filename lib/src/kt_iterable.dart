part of ktc_dart;

extension KtcIterable<E> on Iterable<E> {
  /// Returns a [Map] containing [MapEntry]s provided by [transform] function applied to elements of the given collection.
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(E element) transfrom) =>
      Map.fromEntries(map(transfrom));

  /// Returns a [Map] containing the elements from the given collection indexed by the key returned from [keySelector] function applied to each element.
  Map<K, E> associateBy<K>(K Function(E element) keySelector) =>
      Map.fromIterables(map(keySelector), this);

  /// Returns a [Map] containing the values provided by [valueTransform] and indexed by [keySelector] functions applied to elements of the given collection.
  Map<K, V> transformedAssociateBy<K, V>(
    K Function(E element) keySelector,
    V Function(E element) valueTransform,
  ) =>
      Map.fromIterables(map(keySelector), map(valueTransform));

  /// Returns a [Map] where keys are elements from the given collection and values are produced by the [valueSelector] function applied to each element.
  Map<E, V> associateWith<V>(V Function(E element) valueSelector) =>
      Map.fromIterables(this, map(valueSelector));
}
