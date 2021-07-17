import 'package:test/scaffolding.dart';
import 'package:ktc_dart/ktc_dart.dart';
import 'package:test/test.dart';

void main() {
  late Iterable iterable;

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

    test('transformedAssociateBy', () {
      final associated = iterable.transformedAssociateBy(
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
  });
}
