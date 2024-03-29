import 'package:dump/src/json.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('dumpJson', () {
    test('null', () {
      expect(dumpJson(null), null);
    });

    test('bool', () {
      expect(dumpJson(true), true);
      expect(dumpJson(false), false);
    });

    test('int', () {
      expect(dumpJson(123), 123);
    });

    test('double', () {
      expect(dumpJson(2.718281), 2.718281);
    });

    test('Sting', () {
      expect(dumpJson('abc'), 'abc');
    });

    test('DateTime', () {
      expect(
        dumpJson(DateTime(1999, 1, 2, 3, 4, 5, 6, 1008)),
        {
          '': 'DateTime',
          'isUtc': false,
          'toString()': '1999-01-02 03:04:05.007008',
        },
      );
    });

    test('Enum', () {
      expect(
        dumpJson(MyEnum.one),
        {
          '': 'MyEnum',
          'index': 0,
          'n': 1,
          'name': 'one',
        },
      );
    });

    group('Object', () {
      test('entirely', () {
        expect(
          dumpJson(obj),
          objMap,
        );
      });

      test('hide fields', () {
        expect(
          dumpJson(obj, hideFields: {'', 'b', 'd', 'n', '_private', 'bar'}),
          {
            'nn': null,
            's': 'def',
          },
        );
      });

      test('inheritance', () {
        final map = dumpJson(BarSub(), hideFields: {''}) as Map?;
        expect(map?.keys, ['a', 'n', '_y', 'z']);
        expect(map?.values, [0, 1, 'private', 3]);
      });
    });

    test('List', () {
      expect(
        dumpJson([null, true, false, 1, 1, 2.0, 'a', obj]),
        [null, true, false, 1, 1, 2.0, 'a', objMap],
      );
    });

    test('Set', () {
      expect(
        dumpJson({null, true, false, 1, 2.0, 'a', obj}),
        [null, true, false, 1, 2.0, 'a', objMap],
      );
    });

    test('Map', () {
      expect(
        dumpJson({
          'null': null,
          'bool': true,
          'false': 'false', //              Will be overwritten.
          'int': 1,
          3: 4, //                          Will be overwritten.
          '3': 5,
          'double': 2.0,
          'String': 'a',
          'List': [1, 'a', obj],
          'Set': {2, 'b', obj},
          'Map': {'n': 1, 'obj': obj},
          'Object': obj,
          false: 'true',
          ['a']: ['b'],
        }),
        {
          'null': null,
          'bool': true,
          'false': 'true',
          'int': 1,
          '3': 5,
          'double': 2.0,
          'String': 'a',
          'List': [1, 'a', objMap],
          'Set': {2, 'b', objMap},
          'Map': {'n': 1, 'obj': objMap},
          'Object': objMap,
          '[a]': ['b'],
        },
      );
    });

    group('recursion', () {
      test('no refs', () {
        expect(
          dumpJson(recursive),
          recursiveMap,
        );
      });
    });
  });
}

enum MyEnum {
  one(1),
  two(2),
  ;

  final int n; // ignore: unreachable_from_main, accessed via mirrors.
  const MyEnum(this.n);
}
