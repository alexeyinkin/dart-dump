# dump

Dumps any objects to structures of maps, lists, and scalars using
[mirrors](https://api.dart.dev/stable/2.19.0/dart-mirrors/dart-mirrors-library.html).

The package provides two functions:

## dumpJson

Converts any object to scalar, map, list, or their combination:

```dart
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
//     's': 'def',
//   },
// ]
```

The rules are:

- `null`, `int`, `double`, `bool`, and `String` stay as they are.
- `Interable` is converted to a list, each element is processed recursively.
- `Map` is converted to another map with `.toString()` called on keys,
  values are processed recursively.
- Any other object is converted to a map with the class name under `''` key,
  an entry for each field including private, field values are processed recursively.

## dumpString

Calls `dumpJson` and pretty-prints the result to a string.

## Warning

All formats are subject to change.
Use this to get a human-readable format of data or to compare objects in tests.
Any stored result may be incompatible with future versions.
