extension KtSet<E> on Set<E> {
  /// Splits this collection into a [Set] of iterables each not exceeding the
  /// given [size].
  ///
  /// The last [Set] in the resulting [Set] may have fewer elements than the
  /// given [size].
  Set<Set<E>> chunked(int size) =>
      windowed(size: size, step: size, partialWindows: true);

  /// Splits this collection into several iterables each not exceeding the given
  /// [size] and applies the given [transform] function to an each.
  Set<T> chunkedAndTransform<T>(
    int size,
    T Function(Iterable<E> chunk) transform,
  ) =>
      windowedAndTransform<T>(
        size: size,
        step: size,
        transform: transform,
        partialWindows: true,
      );

  /// Returns an [Iterable] of the valid indices for this collection.
  Iterable<int> get indices => Iterable<int>.generate(length);

  /// Returns a [Set] of snapshots of the window of the given [size] sliding
  /// along this collection with the given [step], where each snapshot is a
  /// [Set].
  Set<Set<E>> windowed({
    required int size,
    int step = 1,
    bool partialWindows = false,
  }) {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be greater than zero');
    }

    if (step <= 0) {
      throw ArgumentError.value(step, 'step', 'must be greater than zero');
    }

    final chunks = <Set<E>>{};
    var index = 0;

    for (final element in this) {
      if (index % step == 0) {
        if (partialWindows) {
          chunks.add({});
        } else if (length - index >= size) {
          chunks.add({});
        }
      }

      for (final chunk in chunks) {
        if (chunk.length < size) chunk.add(element);
      }

      index++;
    }

    return chunks;
  }

  /// Returns a [Set] of results of applying the given [transform] function to
  /// an each [Set] representing a view over the window of the given [size]
  /// sliding along this collection with the given [step].
  Set<R> windowedAndTransform<R>({
    required int size,
    required R Function(Iterable<E> element) transform,
    int step = 1,
    bool partialWindows = false,
  }) {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be greater than zero');
    }

    if (step <= 0) {
      throw ArgumentError.value(step, 'step', 'must be greater than zero');
    }

    final list = <R>{};

    for (final chunk in windowed(
      size: size,
      step: step,
      partialWindows: partialWindows,
    )) {
      list.add(transform(chunk));
    }

    return list;
  }
}
