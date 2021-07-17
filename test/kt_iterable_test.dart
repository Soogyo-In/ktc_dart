import 'package:test/scaffolding.dart';
import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  late Iterable<int> iterable;

  setUp(() {
    iterable = Iterable.generate(3);
  });

  group('Associate', () {
    test('associate', () {
      final associated = iterable.associate((element) => MapEntry(
            element.toString(),
            element * 2,
          ));

      expect(associated, {'0': 0, '1': 2, '2': 4});
    });

    test('associateBy', () {
      final associated = iterable.associateBy((element) => element.toString());

      expect(associated, {'0': 0, '1': 1, '2': 2});
    });

    test('associateAndTransformBy', () {
      final associated = iterable.associateAndTransformBy(
        (element) => element.toString(),
        (element) => element * 2,
      );

      expect(associated, {'0': 0, '1': 2, '2': 4});
    });

    test('associaateWith', () {
      final associated = iterable.associateWith(
        (element) => element.toString(),
      );

      expect(associated, {0: '0', 1: '1', 2: '2'});
    });

    group('Chunked', () {
      test('chunked', () {
        final chunked = iterable.chunked(2);

        expect(chunked, [
          [0, 1],
          [2],
        ]);
      });

      test('chunkedAndTransform', () {
        final chunked = iterable.chunkedAndTransform(
          2,
          (chunk) => chunk.reduce((value, element) => value + element),
        );

        expect(chunked, [1, 2]);
      });
    });
  });
}
