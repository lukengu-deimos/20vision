import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:visionapp/data/models/notification_model.dart';
import 'package:visionapp/data/repositories/alert_repository_impl.dart';
import 'package:visionapp/domain/entities/notification.dart';

abstract interface class AlertLocalDataSource {
  List<Notification> getAlerts();
  bool deleteAlert(int id);
  addAlert(List<NotificationModel> notifications);
}
class AlertLocalDataSourceImpl implements AlertLocalDataSource {

  final Box<Notification> box;
  AlertLocalDataSourceImpl(this.box);

  @override
  List<Notification> getAlerts() {
    List<Notification> alerts = [];
    if(kDebugMode) {
      print('AlertLocalDataSourceImpl.getAlerts()');
      print(box.values.toList());
      print(box.values.toList().length);

    }
    for(Notification alert in box.values){
      alerts.add(alert);
    }
    alerts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return alerts;

  }

  @override
  bool deleteAlert(int id) {
    // TODO: implement deleteAlert
    for( final key in box.keys) {
      if(box.get(key)!.notificationId == id) {
        box.delete(key);
        return true;
      }
    }
    return false;
  }

  @override
  addAlert(List<NotificationModel> notifications) {
    List<int> notificationIds = [];
    for( final key in box.keys) {
      notificationIds.add((box.get(key)!.notificationId));
    }

    for(NotificationModel notification in notifications ){
      if(!notificationIds.contains(notification.notificationId)){
        box.add(notification);
      }
    }
  }


}