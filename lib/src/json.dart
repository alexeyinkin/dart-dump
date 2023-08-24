import 'dart:mirrors';

const _classNameKey = '';

/// Converts any object to scalar, map, list, or their combination.
Object? dumpJson(
  Object? value, {
  Set<String> hideFields = const {},
}) {
  return _dumpJson(
    value,
    hideFields: hideFields,
    visited: {},
  );
}

Object? _dumpJson(
  Object? value, {
  required Set<String> hideFields,
  required Set visited,
}) {
  if (value == null || value is num || value is String || value is bool) {
    return value;
  }

  if (visited.contains(value)) {
    return '(RECURSION)';
  }

  visited.add(value);

  if (value is Map) {
    return _dumpMap(
      value,
      hideFields: hideFields,
      visited: visited,
    );
  }

  if (value is Iterable) {
    return _dumpIterable(
      value,
      hideFields: hideFields,
      visited: visited,
    );
  }

  return _dumpObject(
    value,
    hideFields: hideFields,
    visited: visited,
  );
}

Map<dynamic, dynamic> _dumpMap(
  Map<dynamic, dynamic> map, {
  required Set<String> hideFields,
  required Set visited,
}) {
  return {
    for (final entry in map.entries)
      entry.key.toString(): dumpJson(entry.value),
  };
}

List<Object?> _dumpIterable(
  Iterable<Object?> iterable, {
  required Set<String> hideFields,
  required Set visited,
}) {
  return iterable
      .map(
        (e) => _dumpJson(
          e,
          hideFields: hideFields,
          visited: visited,
        ),
      )
      .toList(growable: false);
}

Map<String, dynamic> _dumpObject(
  Object value, {
  required Set<String> hideFields,
  required Set visited,
}) {
  final im = reflect(value);

  final result = <String, dynamic>{};

  if (!hideFields.contains(_classNameKey)) {
    result[_classNameKey] = MirrorSystem.getName(im.type.simpleName);
  }

  for (final type in im.type.thisAndSuperclasses) {
    for (final entry in type.declarations.entries) {
      final valueMirror = entry.value;

      if (valueMirror is! VariableMirror) continue;
      if (valueMirror.isStatic) continue;

      final key = MirrorSystem.getName(entry.key);
      if (hideFields.contains(key)) continue;

      final symbol = valueMirror.simpleName;
      final reflectee = im
          .getField(symbol)
          .reflectee;

      result[key] = _dumpJson(
        reflectee,
        hideFields: hideFields,
        visited: visited,
      );
    }
  }

  if (value is DateTime) {
    result['toString()'] = value.toString();
  }

  if (value is Enum) {
    result['name'] = value.name;
  }

  return _sortMap(result);
}

Map<String, V> _sortMap<V>(Map<String, V> map) {
  final keys = [...map.keys];
  keys.sort(_compareKeys);
  return { for (final key in keys) key: map[key] as V };
}

int _compareKeys(String a, String b) {
  if (a.startsWith('_')) a = a.substring(1); // ignore: parameter_assignments
  if (b.startsWith('_')) b = b.substring(1); // ignore: parameter_assignments
  return a.compareTo(b);
}

extension on ClassMirror {
  Iterable<ClassMirror> get thisAndSuperclasses sync* {
    yield this;

    if (superclass != null) {
      yield* superclass!.thisAndSuperclasses;
    }
  }
}
