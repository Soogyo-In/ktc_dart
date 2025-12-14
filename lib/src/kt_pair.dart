typedef Pair<A, B> = (A, B);

extension PairExt<T> on Pair<T, T> {
  List<T> toList() => [$1, $2];
}
