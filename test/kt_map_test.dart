import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  late Map<int, String> empty;
  late Map<int, String> map;

  setUp(() {
    empty = <int, String>{};
    map = <int, String>{0: '0', 1: '1'};
  });

  test('any', () {
    bool test(MapEntry<int, String> entry) => entry.key.isNegative;

    expect(empty.any(), false);
    expect(empty.any(test), false);
    expect(map.any(), true);
    expect(map.any(test), false);
    expect(map.any((entry) => !test(entry)), true);
  });

  test('every', () {
    bool keyIsOdd(MapEntry<int, String> entry) => entry.key.isOdd;
    bool keyIsPositive(MapEntry<int, String> entry) => !entry.key.isNegative;

    expect(empty.every(keyIsOdd), false);
    expect(map.every(keyIsOdd), false);
    expect(map.every(keyIsPositive), true);
  });

  group('First', () {
    test('firstNotNullOf', () {
      String? transform(MapEntry<int, String> entry) => entry.value;

      expect(
        () => empty.firstNotNullOf(transform),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(
        () => map.firstNotNullOf(
          (entry) => entry.key.isNegative ? entry.value : null,
        ),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(map.firstNotNullOf(transform), '0');
    });

    test('firstNotNullOfOrNull', () {
      String? transform(MapEntry<int, String> entry) => entry.value;

      expect(
        empty.firstNotNullOfOrNull(transform),
        null,
      );
      expect(
        map.firstNotNullOfOrNull(
          (entry) => entry.key.isNegative ? entry.value : null,
        ),
        null,
      );
      expect(map.firstNotNullOfOrNull(transform), '0');
    });
  });

  test('flatMap', () {
    Iterable transform(MapEntry<int, String> entry) => [entry.key, entry.value];

    expect(empty.flatMap(transform), Iterable.empty());
    expect(map.flatMap(transform), [0, '0', 1, '1']);
  });

  test('fromPairs', () {
    expect(
      KtcMap.fromPairs(Iterable<Pair<int, String>>.empty()),
      <int, String>{},
    );
    expect(
      KtcMap.fromPairs(Iterable<Pair<int, String>>.generate(
        2,
        (index) => Pair(index, index.toString()),
      )),
      {0: '0', 1: '1'},
    );
  });

  group('Get', () {
    test('getOrDefault', () {
      expect(empty.getOrDefault(0, '-1'), '-1');
      expect(map.getOrDefault(-1, '-1'), '-1');
      expect(map.getOrDefault(0, '-1'), '0');
      expect(map.getOrDefault(1, '-1'), '1');
      expect(map.getOrDefault(2, '-1'), '-1');
    });

    test('getOrElse', () {
      String defaultValue() => '-1';

      expect(empty.getOrElse(0, defaultValue), '-1');
      expect(map.getOrElse(-1, defaultValue), '-1');
      expect(map.getOrElse(0, defaultValue), '0');
      expect(map.getOrElse(1, defaultValue), '1');
      expect(map.getOrElse(2, defaultValue), '-1');
    });
  });

  group('Map', () {
    test('mapEntries', () {
      String transform(MapEntry<int, String> entry) =>
          entry.key.toString() + entry.value;

      expect(empty.mapEntries(transform), Iterable<String>.empty());
      expect(map.mapEntries(transform), ['00', '11']);
    });

    test('mapKeys', () {
      String transform(MapEntry<int, String> entry) =>
          entry.key.toString() + entry.value;

      expect(empty.mapKeys(transform), <String, String>{});
      expect(map.mapKeys(transform), {'00': '0', '11': '1'});
    });

    test('mapNotNull', () {
      String? transform(MapEntry<int, String> entry) =>
          entry.key.isOdd ? null : entry.key.toString() + entry.value;

      expect(empty.mapNotNull(transform), <String>[]);
      expect(map.mapNotNull(transform), ['00']);
    });

    test('mapValues', () {
      String transform(MapEntry<int, String> entry) =>
          entry.key.toString() + entry.value;

      expect(empty.mapValues(transform), <String, String>{});
      expect(map.mapValues(transform), {0: '00', 1: '11'});
    });
  });

  group('Max', () {
    test('maxByOrNull', () {
      int selector(MapEntry<int, String> entry) => entry.key;
      var max = empty.maxByOrNull(selector);

      expect(max, null);

      max = map.maxByOrNull(selector)!;

      expect(max.key, 1);
      expect(max.value, '1');
    });

    test('maxOf', () {
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(
        () => empty.maxOf(selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(map.maxOf(selector), 1);
    });

    test('maxOfOrNull', () {
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(empty.maxOfOrNull(selector), null);
      expect(map.maxOfOrNull(selector), 1);
    });

    test('maxOfWith', () {
      int comparator(a, b) => a.compareTo(b);
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(
        () => empty.maxOfWith(comparator, selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(map.maxOfWith(comparator, selector), 1);
    });

    test('maxOfWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(empty.maxOfWithOrNull(comparator, selector), null);
      expect(map.maxOfWithOrNull(comparator, selector), 1);
    });

    test('maxWithOrNull', () {
      int comparator(MapEntry<int, String> a, MapEntry<int, String> b) =>
          a.key.compareTo(b.key);
      var max = empty.maxWithOrNull(comparator);

      expect(max, null);

      max = map.maxWithOrNull(comparator)!;

      expect(max.key, 1);
      expect(max.value, '1');
    });
  });

  group('Min', () {
    test('minByOrNull', () {
      int selector(MapEntry<int, String> entry) => entry.key;
      var min = empty.minByOrNull(selector);

      expect(min, null);

      min = map.minByOrNull(selector)!;

      expect(min.key, 0);
      expect(min.value, '0');
    });

    test('minOf', () {
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(
        () => empty.minOf(selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(map.minOf(selector), 0);
    });

    test('minOfOrNull', () {
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(empty.minOfOrNull(selector), null);
      expect(map.minOfOrNull(selector), 0);
    });

    test('minOfWith', () {
      int comparator(a, b) => a.compareTo(b);
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(
        () => empty.minOfWith(comparator, selector),
        throwsA(isA<NoSuchElementException>()),
      );
      expect(map.minOfWith(comparator, selector), 0);
    });

    test('minOfWithOrNull', () {
      int comparator(int a, int b) => a.compareTo(b);
      int selector(MapEntry<int, String> entry) => entry.key;

      expect(empty.minOfWithOrNull(comparator, selector), null);
      expect(map.minOfWithOrNull(comparator, selector), 0);
    });

    test('minWithOrNull', () {
      int comparator(MapEntry<int, String> a, MapEntry<int, String> b) =>
          a.key.compareTo(b.key);
      var min = empty.minWithOrNull(comparator);

      expect(min, null);

      min = map.minWithOrNull(comparator)!;

      expect(min.key, 0);
      expect(min.value, '0');
    });
  });

  test('none', () {
    expect(empty.none(), true);
    expect(map.none(), false);
    expect(map.none((entry) => entry.key.isOdd), false);
    expect(map.none((entry) => entry.key.isNegative), true);
  });

  group('OnEach', () {
    test('onEach', () {
      var idx = 0;
      void action(MapEntry<int, String> entry) {
        expect(entry.key, idx);
        expect(entry.value, idx.toString());
        idx++;
      }

      expect(empty.onEach(action), empty);
      expect(map.onEach(action), map);
    });

    test('onEachIndexed', () {
      var idx = 0;
      void action(int index, MapEntry<int, String> entry) {
        expect(entry.key, idx);
        expect(entry.value, idx.toString());
        expect(index, idx);
        idx++;
      }

      expect(empty.onEachIndexed(action), empty);
      expect(map.onEachIndexed(action), map);
    });
  });

  group('Where', () {
    test('where', () {
      bool test(MapEntry<int, String> entry) => entry.key.isOdd;

      expect(empty.where(test), {});
      expect(map.where(test), {1: '1'});
    });

    test('whereKeys', () {
      bool test(int key) => key.isOdd;

      expect(empty.whereKeys(test), {});
      expect(map.whereKeys(test), {1: '1'});
    });

    test('whereNot', () {
      bool test(MapEntry<int, String> entry) => entry.key.isOdd;

      expect(empty.whereNot(test), {});
      expect(map.whereNot(test), {0: '0'});
    });

    test('whereValues', () {
      bool test(String value) => int.parse(value).isOdd;

      expect(empty.whereValues(test), {});
      expect(map.whereValues(test), {1: '1'});
    });
  });

  group('Operator', () {
    test('-', () {
      expect(empty - [1], <int, String>{});
      expect(map - [1], {0: '0'});
      expect(map - [2], {0: '0', 1: '1'});
    });

    test('+', () {
      expect(empty + [MapEntry(1, '1')], {1: '1'});
      expect(map + [MapEntry(1, '1')], {0: '0', 1: '1'});
      expect(map + [MapEntry(2, '2')], {0: '0', 1: '1', 2: '2'});
    });
  });
}
