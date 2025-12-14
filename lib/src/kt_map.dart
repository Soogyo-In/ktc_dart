import 'kt_iterable.dart';
import 'kt_pair.dart';

extension KtcMap<K, V> on Map<K, V> {
  static Map<K, V> fromPairs<K, V>(Iterable<Pair<K, V>> pairs) {
    final map = <K, V>{};

    for (final pair in pairs) {
      map[pair.first] = pair.second;
    }

    return map;
  }

  /// Returns `true` if at least one entry passes the given [test] or [Map] has
  /// at least one entry.
  bool any([bool Function(MapEntry<K, V> entry)? test]) {
    for (final entry in entries) {
      if (test?.call(entry) ?? true) return true;
    }

    return false;
  }

  /// Returns `true` if all entries pass the given [test].
  bool every(bool Function(MapEntry<K, V> entry) test) {
    for (final entry in entries) {
      if (!test(entry)) return false;
    }

    return isNotEmpty;
  }

  /// Returns the first non-null value produced by [transform] function being
  /// applied to entries of this [Map] in iteration order, or throws
  /// [NoSuchElementException] if no non-null value was produced.
  R firstNotNullOf<R>(R? Function(MapEntry<K, V> entry) transform) =>
      entries.firstNotNullOf((entry) => transform(entry));

  /// Returns the first non-null value produced by [transform] function being
  /// applied to entries of this [Map] in iteration order, or null if no
  /// non-null value was produced.
  R? firstNotNullOfOrNull<R>(R? Function(MapEntry<K, V> entry) transform) =>
      entries.firstNotNullOfOrNull((entry) => transform(entry));

  /// Returns a single [Iterable] of all elements yielded from results of
  /// [transform] function being invoked on each entry of original [Map].
  Iterable<R> flatMap<R>(
    Iterable<R> Function(MapEntry<K, V> entry) transform,
  ) =>
      entries.flatMap(transform);

  /// Returns the value corresponding to the given [key], or [defaultValue] if
  /// such a [key] is not present in the [Map].
  V getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Returns the value for the given [key], or the result of the [defaultValue]
  /// function if there was no entry for the given [key].
  V getOrElse(K key, V Function() defaultValue) => this[key] ?? defaultValue();

  /// Returns an [Iterator] over the entries in the [Map].
  Iterator<MapEntry<K, V>> get iterator => entries.iterator;

  /// Returns a [Iterable] containing the results of applying the given
  /// [transform] function to each entry in the original [Map].
  Iterable<R> mapEntries<R>(R Function(MapEntry<K, V> entry) transform) =>
      entries.map(transform);

  /// Returns a new [Map] with entries having the keys obtained by applying the
  /// [transform] function to each entry in this [Map] and the values of this
  /// [Map].
  Map<R, V> mapKeys<R>(R Function(MapEntry<K, V> entry) transform) =>
      Map.fromIterables(entries.map(transform), values);

  /// Returns a [Iterable] containing only the non-null results of applying the
  /// given [transform] function to each entry in the original [Map].
  Iterable<R> mapNotNull<R>(R? Function(MapEntry<K, V> entry) transform) =>
      entries.mapNotNull(transform);

  /// Returns a new [Map] with entries having the keys of this [Map] and the
  /// values obtained by applying the [transform] function to each entry in this
  /// [Map].
  Map<K, R> mapValues<R>(R Function(MapEntry<K, V> entry) transform) =>
      Map.fromIterables(keys, entries.map(transform));

  /// Returns the first entry yielding the largest value of the given function
  /// or `null` if there are no entries.
  MapEntry<K, V>? maxByOrNull<R extends Comparable>(
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.maxByOrNull(selector);

  /// Returns the largest value among all values produced by [selector] function
  /// applied to each entry in the [Map].
  R maxOf<R extends Comparable>(R Function(MapEntry<K, V> entry) selector) =>
      entries.maxOf(selector);

  /// Returns the largest value among all values produced by [selector] function
  /// applied to each entry in the [Map] or `null` if there are no entries.
  R? maxOfOrNull<R extends Comparable>(
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.maxOfOrNull(selector);

  /// Returns the largest value according to the provided [comparator] among all
  /// values produced by [selector] function applied to each entry in the [Map].
  R maxOfWith<R>(
    Comparator<R> comparator,
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.maxOfWith(comparator, selector);

  /// Returns the largest value according to the provided [comparator] among all
  /// values produced by [selector] function applied to each entry in the map or
  /// `null` if there are no entries.
  R? maxOfWithOrNull<R>(
    Comparator<R> comparator,
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.maxOfWithOrNull(comparator, selector);

  /// Returns the first entry having the largest value according to the provided
  /// [comparator] or `null` if there are no entries.
  MapEntry<K, V>? maxWithOrNull(Comparator<MapEntry<K, V>> comparator) =>
      entries.maxWithOrNull(comparator);

  /// Returns the first entry yielding the smallest value of the given function
  /// or `null` if there are no entries.
  MapEntry<K, V>? minByOrNull<R extends Comparable>(
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.minByOrNull(selector);

  /// Returns the smallest value among all values produced by [selector]
  /// function applied to each entry in the [Map].
  R minOf<R extends Comparable>(R Function(MapEntry<K, V> entry) selector) =>
      entries.minOf(selector);

  /// Returns the smallest value among all values produced by [selector]
  /// function applied to each entry in the [Map] or `null` if there are no
  /// entries.
  R? minOfOrNull<R extends Comparable>(
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.minOfOrNull(selector);

  /// Returns the smallest value according to the provided [comparator] among
  /// all values produced by [selector] function applied to each entry in the
  /// [Map].
  R minOfWith<R>(
    Comparator<R> comparator,
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.minOfWith(comparator, selector);

  /// Returns the smallest value according to the provided [comparator] among
  /// all values produced by [selector] function applied to each entry in the
  /// [Map] or `null` if there are no entries.
  R? minOfWithOrNull<R>(
    Comparator<R> comparator,
    R Function(MapEntry<K, V> entry) selector,
  ) =>
      entries.minOfWithOrNull(comparator, selector);

  /// Returns the first entry having the smallest value according to the
  /// provided [comparator] or `null` if there are no entries.
  MapEntry<K, V>? minWithOrNull(Comparator<MapEntry<K, V>> comparator) =>
      entries.minWithOrNull(comparator);

  /// Returns `true` if the map has no entries.
  ///
  /// If [test] is provided it returns `true` if no entries match the given
  /// [test].
  bool none([bool Function(MapEntry<K, V> entry)? test]) => entries.none(test);

  /// Performs the given [action] on each entry and returns the [Map] itself
  /// afterwards.
  Map<K, V> onEach(void Function(MapEntry<K, V> entry) action) {
    entries.onEach(action);

    return this;
  }

  /// Performs the given [action] on each entry, providing sequential index with
  /// the entry, and returns the [Map] itself afterwards.
  Map<K, V> onEachIndexed(
    void Function(int index, MapEntry<K, V> entry) action,
  ) {
    entries.onEachIndexed(action);

    return this;
  }

  /// Returns a new [Map] containing all key-value pairs passing the given
  /// [test].
  Map<K, V> where(bool Function(MapEntry<K, V> entry) test) =>
      Map.fromEntries(entries.where((entry) => test(entry)));

  /// Returns a [Map] containing all key-value pairs with keys passing the given
  /// [test].
  Map<K, V> whereKeys(bool Function(K key) test) =>
      Map.fromEntries(entries.where((entry) => test(entry.key)));

  /// Returns a new [Map] containing all key-value pairs not passing the given
  /// [test].
  Map<K, V> whereNot(bool Function(MapEntry<K, V> entry) test) =>
      Map.fromEntries(entries.whereNot(test));

  /// Returns a [Map] containing all key-value pairs with values passing the
  /// given [test].
  Map<K, V> whereValues(bool Function(V value) test) =>
      Map.fromEntries(entries.where((entry) => test(entry.value)));

  /// Returns a [Map] containing all entries of the original [Map] except those
  /// entries the keys of which are contained in the given [keys] collection.
  Map<K, V> operator -(Iterable<K> keys) =>
      whereNot((entry) => keys.contains(entry.key));

  /// Creates a new [Map] by replacing or adding entries to this [Map] from a
  /// given collection of key-value [entries].
  Map<K, V> operator +(Iterable<MapEntry<K, V>> entries) =>
      Map.fromEntries([...this.entries, ...entries]);
}
