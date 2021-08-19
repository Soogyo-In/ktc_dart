part of ktc_dart;

extension KtcSet<E> on Set<E> {
  /// Returns an [Set] containing all elements of the original collection
  /// except the elements contained in the [other] collection.
  Set<E> operator -(Iterable<E> other) => difference(other.toSet());

  /// Returns an [Set] containing all elements of the original collection
  /// and then all elements of the [other] collection.
  Set<E> operator +(Iterable<E> other) => {...this, ...other};

  /// Returns an [Set] that has been removed by the number of [count] from the
  /// beginning.
  ///
  /// If [count] is negative it `throws` [ArgumentError].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  Set<E> operator <<(int count) => count.isNegative
      ? throw ArgumentError.value(count, 'count', 'Cannot be negative')
      : count > length
          ? {}
          : skip(count).toSet();

  /// Returns an [Set] that has been removed by the number of [count] from the
  /// end.
  ///
  /// If [count] is negative it `throws` [ArgumentError].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  Set<E> operator >>(int count) => count.isNegative
      ? throw ArgumentError.value(count, 'count', 'Cannot be negative')
      : count > length
          ? {}
          : take(length - count).toSet();

  /// Returns a [Set] containing all elements that are contained by both this
  /// collection and the specified collection.
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  Set<E> operator &(Iterable<E> other) => intersection(other.toSet());

  /// Returns a [Set] containing all [distinct] elements from both collections.
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  Set<E> operator |(Iterable<E> other) => union(other.toSet());

  /// Returns a [Set] containing all elements from both collections without
  /// [intersect].
  ///
  /// It is not in the Kotlin collection library. But I added it because it
  /// looks useful.
  Set<E> operator ^(Iterable<E> other) => (this - other) | (other - this);
}
