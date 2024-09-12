// ignore_for_file: flutter_style_todos, unnecessary_lambdas

import 'dart:convert';

Map<String, String> holidayFromJson(String str) =>
    // ignore: inference_failure_on_instance_creation, always_specify_types
    Map.from(json.decode(str) as Map<dynamic, dynamic>)
        // ignore: always_specify_types
        .map((k, v) => MapEntry<String, String>(k as String, v as String));

String holidayToJson(Map<String, String> data) => json.encode(
    // ignore: inference_failure_on_instance_creation, always_specify_types
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k as String, v)));

class Holiday {
  Holiday({required this.date, required this.content});

  String date;
  String content;
}
