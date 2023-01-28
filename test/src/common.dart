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
  final bar = Bar();

  static int staticIsIgnored = 1; // ignore: prefer_const_declarations
  static const staticConstIsIgnored = 1;
  void methodIsIgnored() {}
}

class Bar {
  final n = 1;
}

final obj = Foo(
  b: false,
  d: 3.1415926,
  n: 456,
  s: 'def',
);

final objMap = {
  '': 'Foo',
  'b': false,
  'd': 3.1415926,
  'n': 456,
  'nn': null,
  's': 'def',
  '_private': 'private',
  'bar': {
    '': 'Bar',
    'n': 1,
  },
};

class Recursive {
  late Recursive self = this;
}

final recursive = Recursive();
final recursiveMap = {
  '': 'Recursive',
  'self': '(RECURSION)',
};
