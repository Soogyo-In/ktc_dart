## 1.0.1

### Fixes
- Fixed `sortedBy` and `sortedByDescending` methods where list elements were lost during sorting.

### Chore
- Minimum Dart SDK version is now 3.1.0.

### Deprecations
- Deprecated `sum` getter. Use `sum` from the collection package instead.
- Deprecated `whereNotNull` getter. Use `whereNotNull()` from the collection package or `nonNulls` from the Dart SDK instead.
- Deprecated `indexOf()` method. Use `indexOf()` from the Dart SDK instead.
- Deprecated `lastIndexOf()` method. Use `lastIndexOf()` from the Dart SDK instead.
- Deprecated `lastOrNull` getter. Use `lastOrNull` from the collection package instead.
- Deprecated `lastWhereOrNull()` method. Use `lastWhereOrNull()` from the collection package instead.
- Deprecated `reversed` getter. Use `reversed` from the Dart SDK instead.
- Deprecated `shuffled()` method. Use `shuffled()` from the collection package instead.
- Deprecated `singleOrNull` getter. Use `singleOrNull` from the collection package instead.
- Deprecated `singleWhereOrNull()` method. Use `singleWhereOrNull()` from the collection package instead.
- Deprecated `sortedBy()` method. Use `sortedBy()` from the collection package instead.
- Deprecated `whereIsInstance<T>()` method. Use `whereType<T>()` from the Dart SDK instead.
- Deprecated `whereNot()` method. Use `whereNot()` from the collection package instead.
- Deprecated `withIndex` getter. Use `indexed` from the Dart SDK instead.
- Deprecated `Pair` class. Will be converted to Record since Dart 3.0 supports Records.
- Deprecated `IndexedValue` class. Will be removed since Dart SDK supports indexed getter.
- Deprecated `IndexedValueIterable` class. Will be removed since Dart SDK supports indexed getter.
- Deprecated `IndexedValueIterator` class. Will be removed since Dart SDK supports indexed getter.

## 1.0.0

### Updates
- Implemented `Map`.

## 0.3.0

### Updates
- Implemented `Set`.
- Implemented `Collection` library from `Kotlin` to `KtcIterable`.
- Removed all `Iterable` return methods in `KtcList`.

## 0.2.0

### Updates
- Implemented `List`.

## 0.1.2

### Amends
- Changed behavior of `>>` operator. It returns an empty `Iterable` when the `count` parameter is greater than its `length`.

## 0.1.1

### Amends
- Changed `whereNotNull` to `getter`.

### Fixes
- The `average` returns `0` if the collection is empty.
- The `sum` returns `0` if the collection is empty.
- The `sumOf` returns `0` if the collection is empty.
- The `windowedAndTransform` returns `Iterable<R>`. I accidentally wrote the wrong return type.

## 0.1.0

### Updates
- Implemented `Iterable`.
