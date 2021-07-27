part of ktc_dart;

class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair && first == other.first && second == other.second;
}

extension PairExt<T> on Pair<T, T> {
  List<T> toList() => [first, second];
}
