import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:ktc_dart/src/kt_set.dart';

void main() {
  final empty = <int>{};
  late Set<int> set;
  late Set<int> reversedSet;

  setUp(() {
    set = {0, 1, 2};
    reversedSet = {2, 1, 0};
  });

  group('Chunked', () {
    test('chunked', () {
      expect(() => empty.chunked(-1), throwsArgumentError);
      expect(() => empty.chunked(0), throwsArgumentError);
      expect(empty.chunked(1), <int>{});
      expect(() => set.chunked(-1), throwsArgumentError);
      expect(() => set.chunked(0), throwsArgumentError);
      expect(set.chunked(1), {
        {0},
        {1},
        {2},
      });
      expect(set.chunked(2), {
        {0, 1},
        {2},
      });
      expect(set.chunked(3), {
        {0, 1, 2}
      });
      expect(set.chunked(4), {
        {0, 1, 2}
      });
    });

    test('chunkedAndTransform', () {
      expect(empty, <int>{});
      expect(
        set.chunkedAndTransform(
          2,
          (chunk) => chunk.reduce((value, element) => value + element),
        ),
        {1, 2},
      );
    });
  });

  group('flat', () {
    test('flatMap', () {
      Iterable<String> transform(int element) => Iterable.generate(
            element,
            (index) => index.toString(),
          );

      expect(empty.flatMap(transform), <int>{});
      expect(set.flatMap(transform), {'0', '1'});
    });

    test('flatMapIndexed', () {
      Iterable<String> transform(int index, int element) => Iterable.generate(
            element,
            (_index) => (_index + index).toString(),
          );

      expect(empty.flatMapIndexed(transform), <int>{});
      expect(set.flatMapIndexed(transform), {'1', '2', '3'});
    });

    test('flatten', () {
      expect({<int>{}}.flatten, <int>{});
      expect(
        {
          [0, 1],
          [1, 2],
        }.flatten,
        {0, 1, 2},
      );

      expect(
        {
          {0, 1},
          {
            {0, 1},
          },
        }.flatten,
        {
          0,
          1,
          [0, 1],
        },
      );
    });
  });

  test('indices', () {
    expect(empty.indices, Iterable.empty());
    expect(set.indices, Iterable.generate(3));
  });

  group('Windowed', () {
    test('windowed', () {
      final set = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

      expect(empty.windowed(size: 1), <int>{});
      expect(
        () => set.windowed(size: -1, step: -1),
        throwsArgumentError,
      );
      expect(
        () => set.windowed(size: 0, step: -1),
        throwsArgumentError,
      );
      expect(
        () => set.windowed(size: 0, step: 0),
        throwsArgumentError,
      );
      expect(
        () => set.windowed(size: 1, step: 0),
        throwsArgumentError,
      );
      expect(
        set.windowed(size: 5),
        {
          {0, 1, 2, 3, 4},
          {1, 2, 3, 4, 5},
          {2, 3, 4, 5, 6},
          {3, 4, 5, 6, 7},
          {4, 5, 6, 7, 8},
          {5, 6, 7, 8, 9},
        },
      );
      expect(
        set.windowed(size: 5, step: 3),
        {
          {0, 1, 2, 3, 4},
          {3, 4, 5, 6, 7},
        },
      );
      expect(
        set.windowed(
          size: 5,
          step: 3,
          partialWindows: true,
        ),
        {
          {0, 1, 2, 3, 4},
          {3, 4, 5, 6, 7},
          {6, 7, 8, 9},
          {9},
        },
      );
    });

    test('windowedAndTransform', () {
      final set = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
      int transform(Iterable<int> chunk) =>
          chunk.reduce((value, element) => value + element);

      expect(
        empty.windowedAndTransform(size: 1, transform: transform),
        <int>{},
      );
      expect(
        () => set.windowedAndTransform(
          size: -1,
          step: -1,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => set.windowedAndTransform(
          size: 0,
          step: -1,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => set.windowedAndTransform(
          size: 0,
          step: 0,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        () => set.windowedAndTransform(
          size: 1,
          step: 0,
          transform: transform,
        ),
        throwsArgumentError,
      );
      expect(
        set.windowedAndTransform(size: 5, transform: transform),
        {10, 15, 20, 25, 30, 35},
      );
      expect(
        set.windowedAndTransform(
          size: 5,
          step: 3,
          transform: transform,
        ),
        {10, 25},
      );
      expect(
        set.windowedAndTransform(
          size: 5,
          step: 3,
          transform: transform,
          partialWindows: true,
        ),
        {10, 25, 30, 9},
      );
    });
  });
}
