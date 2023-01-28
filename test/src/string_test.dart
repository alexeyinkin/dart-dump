import 'package:dump/src/string.dart';
import 'package:test/test.dart';

void main() {
  group('dumpString', () {
    test('null', () {
      expect(dumpString(null), 'null');
    });

    test('bool', () {
      expect(dumpString(true), 'true');
      expect(dumpString(false), 'false');
    });

    test('int', () {
      expect(dumpString(123), '123');
    });

    test('double', () {
      expect(dumpString(2.718281), '2.718281');
    });

    test('Sting', () {
      expect(dumpString('abc'), '"abc"');
    });

    // TODO(alexeyinkin): Test object and collections.
  });
}
