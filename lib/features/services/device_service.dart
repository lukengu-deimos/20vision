import 'dart:convert';

import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/core/utils/device.dart';
import 'package:visionapp/domain/enums/http_method.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/features/services/vision_api.dart';



class DeviceService extends VisionApi {

  DeviceService(super.service);


  Future<String> registerDeviceToUser(int userId) async {
     final endpoint = "users/$userId" ;
     print(endpoint);

     final device = await  Device.instance.checkDevice();
     try {
       final response = await super.execute(path: endpoint,
           method: HttpMethod
               .put,
           body: {'deviceId': device['id']},
           headers: await super.headers);
       if (response.statusCode == 200) {
         final result = BaseResponse<Map<String, dynamic>>.fromJson(
             response.data);

         if (result.success) {
           return device['id'];
         }
       }
     } on ServiceException catch (e) {}
     return "";
  }
}