import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/config/twilio_config.dart';

abstract class NotificationService {
  Future<void> sendSMS({required String to, required String message});
}

class NotificationServiceImpl implements NotificationService {


  @override
  Future<void> sendSMS({required String to, required String message}) async {
    final config = await TwilioConfig.load();
    //Send SMS
    TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: config.accountSid,
      authToken: config.authToken,
      twilioNumber: config.phoneNumner,
    );
    try {
      await twilioFlutter.sendSMS(
        toNumber: to,
        messageBody: message,
      );

    } catch (e) {
      throw const ServiceException('Failed to send SMS');
    }
  }



}