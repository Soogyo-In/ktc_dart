# ktc_dart
A package that implemented the features of the `Collections` library of `Kotlin` (v1.5).

## Differences
This package made `Dart` friendly. So there's are some differences as below.

1. Not implemented which if `Dart` has same feature but different name. 
2. From 1. If there are sibling features. The name of features follows the `Dart` method name.
3. As 2. If there are arguments that has same functionality. The name of arguments follows the `Dart` arguments name.
4. Returns `Iterable` as can as possible when the return type is collection.
5. Unlike `Kotlin`, `Dart` has no `method overloading`. So there are some features that can not implement to same name. When then change name slight differently. For example overloading methods `associateBy(keySelector)` and `associateBy(keySelector, valueTransform)` in `Kotlin` are splitted to two method as `associateBy(keySelector)` and `associateAndTransformBy(keySelector, valueTransfrom)`.

## Todos
- [x] Iterable
- [x] List
- [x] Set
- [x] Map
