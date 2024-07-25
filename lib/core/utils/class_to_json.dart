import 'dart:convert';

abstract interface class JsonSerializable {
  Map<String, dynamic> toJson();
}

List<T> fromJsonList<T>(Map<String, dynamic> jsonList,
    T Function(dynamic json) fromJson, String key) {
  if (jsonList[key] is String) {
    Iterable iterable = jsonDecode(jsonList[key]);
    return iterable.map<T>((json) => fromJson(json)).toList();
  }

  return jsonList[key].map<T>((json) => fromJson(json)).toList();
}

String encodeToJson<T extends JsonSerializable>(List<T> items) {
  return jsonEncode(items.map((e) => e.toJson()).toList());
}
