import 'dart:convert';

import 'json.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// Calls [dumpJson] and pretty-prints the result to a string.
String dumpString(Object? value) {
  return _encoder.convert(dumpJson(value));
}
