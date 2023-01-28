import 'package:dump/dump.dart';

class Foo {
  Foo({
    required this.b,
    required this.d,
    required this.n,
    required this.s,
    this.nn,
  });

  bool b;
  final double d;
  int n;
  int? nn;
  String s;
  final _private = 'private'; // ignore: unused_field

  void method() {}
}

final toDump = [
  1,
  'string',
  Foo(
    b: false,
    d: 3.1415926,
    n: 456,
    s: 'def',
  ),
];

final dumped = dumpJson(toDump);
// Result:
// [
//   1,
//   'string',
//   {
//     '': 'Foo',
//     'b': false,
//     'd': 3.1415926,
//     'n': 456,
//     'nn': null,
//     's': 'def',
//     '_private': 'private',
//   },
// ]
