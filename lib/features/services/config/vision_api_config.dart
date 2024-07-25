import 'dart:convert';
import 'package:flutter/services.dart';

class VisionApiConfig {
  final String endpoint;
  final String username;
  final String password;
  final String tokenUrl;

  VisionApiConfig({
    required this.endpoint,
    required this.username,
    required this.password,
    required this.tokenUrl,
  });

  factory VisionApiConfig.fromJson(Map<String, dynamic> json) {
    return VisionApiConfig(
        endpoint: json['endpoint'],
        username: json['username'],
        password: json['password'],
        tokenUrl: json['token_url'],

    );
  }

  static Future<VisionApiConfig> load() async {
    final String jsonString = await rootBundle.loadString('20vision.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return VisionApiConfig.fromJson(jsonMap);
  }
}
