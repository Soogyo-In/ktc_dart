@Deprecated('Will be removed since Dart SDK supports indexed getter')
class IndexedValue<T> {
  final int index;
  final T value;

  const IndexedValue(this.index, this.value);

  @override
  int get hashCode => index.hashCode ^ value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndexedValue && index == other.index && value == other.value;
}

@Deprecated('Will be removed since Dart SDK supports indexed getter')
class IndexedValueIterable<E> extends Iterable<IndexedValue<E>> {
  final Iterable<E> _iterable;

  IndexedValueIterable(this._iterable);

  @override
  Iterator<IndexedValue<E>> get iterator =>
      IndexedValueIterator(_iterable.iterator);
}

@Deprecated('Will be removed since Dart SDK supports indexed getter')
class IndexedValueIterator<E> implements Iterator<IndexedValue<E>> {
  final Iterator<E> _iterator;
  int _index = -1;

  IndexedValueIterator(this._iterator);

  @override
  IndexedValue<E> get current => IndexedValue(_index, _iterator.current);

  @override
  bool moveNext() {
    if (_iterator.moveNext()) {
      _index++;

      return true;
    }

    return false;
  }
}
