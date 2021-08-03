part of ktc_dart;

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
