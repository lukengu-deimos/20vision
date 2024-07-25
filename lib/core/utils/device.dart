import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class Device {
  Device._();
  static final Device _instance = Device._();
  // Getter method to access the instance
  static Device get instance => _instance;

  Future<Map<String,dynamic>> checkDevice() async {
    BaseDeviceInfo info = await DeviceInfoPlugin().deviceInfo;
    String id  = await _getDeviceId(info.data['systemName']);
    Map<String,dynamic> device = {};
    device['id'] =  id;
    device['model'] = info.data['model'];
    device['machine'] = info.data['systemName'] == 'iOS' ?  info.data['utsname']['machine']: info.data['type'];
    device['isPhysicalDevice'] = info.data['isPhysicalDevice'];

    return device;
  }

  Future<String> _getDeviceId(String ?platform) async {
    String ?deviceId = await MobileDeviceIdentifier().getDeviceId();
    if(platform == 'iOS') {
      return deviceId!;
    }
    var bytes = utf8.encode(deviceId!);
    return sha256.convert(bytes).toString();
  }

}