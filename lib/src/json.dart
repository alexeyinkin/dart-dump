import 'dart:mirrors';

/// Converts any object to scalar, map, list, or their combination.
Object? dumpJson(Object? value) {
  if (value == null || value is num || value is String || value is bool) {
    return value;
  }

  if (value is Map) {
    return _dumpMap(value);
  }

  if (value is Iterable) {
    return _dumpIterable(value);
  }

  return _dumpObject(value);
}

Map<dynamic, dynamic> _dumpMap(Map<dynamic, dynamic> map) {
  return {
    for (final entry in map.entries)
      entry.key.toString(): dumpJson(entry.value),
  };
}

List<Object?> _dumpIterable(Iterable<Object?> iterable) {
  return iterable.map(dumpJson).toList(growable: false);
}

Map<String, dynamic> _dumpObject(Object value) {
  final im = reflect(value);

  final result = <String, dynamic>{
    '': MirrorSystem.getName(im.type.simpleName),
  };

  for (final entry in im.type.declarations.entries) {
    final valueMirror = entry.value;

    if (valueMirror is! VariableMirror) continue;

    final key = MirrorSystem.getName(entry.key);
    final value = im.getField(valueMirror.simpleName).reflectee;
    result[key] = value;
  }

  return result;
}
