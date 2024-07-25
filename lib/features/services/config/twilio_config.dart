import 'dart:convert';
import 'package:flutter/services.dart';

class TwilioConfig {
  final String accountSid;
  final String authToken;
  final String verifyServiceSid;
  final String messageServiceSid;
  final String phoneNumner;

  TwilioConfig({
    required this.accountSid,
    required this.authToken,
    required this.verifyServiceSid,
    required this.messageServiceSid,
    required this.phoneNumner,
  });
  factory TwilioConfig.fromJson(Map<String, dynamic> json) {
    return TwilioConfig(
      accountSid: json['account_sid'],
      authToken: json['auth_token'],
      verifyServiceSid: json['verify']['service_sid'],
      messageServiceSid: json['message']['service_sid'],
      phoneNumner: json['message']['phone_number'],
    );
  }

  static Future<TwilioConfig> load() async {
    final String jsonString = await rootBundle.loadString('twilio.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return TwilioConfig.fromJson(jsonMap);
  }
}
