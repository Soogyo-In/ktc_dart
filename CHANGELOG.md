## 0.1.1
### Amends
- Change `whereNotNull` to `getter`.

### Fixes
- The `average` returns `0` if the collection is empty.
- The `sum` returns `0` if the collection is empty.
- The `sumOf` returns `0` if the collection is empty.
- The `windowedAndTransform` returns `Iterable<R>`. I accidentally wrote the wrong return type.

## 0.1.0

- Implement `Iterable`.