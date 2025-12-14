# ktc_dart
A package that implemented the features of the `Collections` library of `Kotlin` (v1.5).

## Differences
This package made `Dart` friendly. So there's are some differences as below.

1. Not implemented which if `Dart` has same feature but different name. 
2. From 1. If there are sibling features. The name of features follows the `Dart` method name.
3. As 2. If there are arguments that has same functionality. The name of arguments follows the `Dart` arguments name.
4. Returns `Iterable` as can as possible when the return type is collection.
5. Unlike `Kotlin`, `Dart` has no `method overloading`. So there are some features that can not implement to same name. When then change name slight differently. For example overloading methods `associateBy(keySelector)` and `associateBy(keySelector, valueTransform)` in `Kotlin` are splitted to two method as `associateBy(keySelector)` and `associateAndTransformBy(keySelector, valueTransfrom)`.

## Migration Guide (1.x → 2.x)

### Requirements
- Dart SDK `^3.0.0` is now required.
- Add `collection: ^1.19.1` to your dependencies.

### Breaking Changes

#### 1. `Pair` class replaced with Record type
```dart
// Before (1.x)
final pair = Pair(1, 'a');
print(pair.first);   // 1
print(pair.second);  // 'a'

// After (2.x)
final pair = (1, 'a');
print(pair.$1);  // 1
print(pair.$2);  // 'a'
```

#### 2. `withIndex` replaced with `indexed`
```dart
// Before (1.x)
iterable.withIndex.forEach((iv) {
  print('${iv.index}: ${iv.value}');
});

// After (2.x)
iterable.indexed.forEach((iv) {
  print('${iv.$1}: ${iv.$2}');
});
```

#### 3. Removed APIs (use Dart SDK or `collection` package instead)

| Removed | Replacement |
|---------|-------------|
| `withIndex` | `indexed` (Dart SDK) |
| `reversed` | `reversed` (Dart SDK) |
| `indexOf` | `indexOf` (Dart SDK) |
| `lastIndexOf` | `lastIndexOf` (Dart SDK) |
| `whereIsInstance<T>` | `whereType<T>` (Dart SDK) |
| `sum` | `sum` (collection) |
| `whereNotNull` | `nonNulls` (Dart SDK) or `whereNotNull` (collection) |
| `lastOrNull` | `lastOrNull` (collection) |
| `lastWhereOrNull` | `lastWhereOrNull` (collection) |
| `singleOrNull` | `singleOrNull` (collection) |
| `singleWhereOrNull` | `singleWhereOrNull` (collection) |
| `sortedBy` | `sortedBy` (collection) |
| `shuffled` | `shuffled` (collection) |
| `whereNot` | `whereNot` (collection) |
| `none` | `none` (collection) |

#### 4. Signature changes

| Method | Change |
|--------|--------|
| `mapIndexedNotNull<R>` | `R` → `R extends Object` |
| `mapNotNull<R>` | `R` → `R extends Object` |
| `none(test)` | Optional parameter → Required parameter |
