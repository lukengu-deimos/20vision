import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:visionapp/core/constants/constants.dart';
import 'package:visionapp/core/utils/notification_utils.dart';
import 'package:visionapp/core/utils/text_util.dart';
import 'package:visionapp/domain/entities/notification.dart' as Notification;

class AmqpClient {
 // final client = Client();
  String generalTopic = "20Vision.News.General";


  ConnectionSettings get connectionSettings => ConnectionSettings(
      host: kQueueService['endpoint']!!,
      authProvider: PlainAuthenticator(kQueueService['username']!!,
          kQueueService['password']!!),
  );

  Client get client => Client(settings:connectionSettings);

  setupConsumers(String deviceId) async {

    Channel channel = await client.channel();
    await createAndConsumeQueue(channel, deviceId);
    addAndConsumeTopic(channel, generalTopic, deviceId);
    //addAndConsumeTopic(channel, deviceId, deviceId);
  }

  Future<void> createAndConsumeQueue(Channel channel, String queueName)
  async {
    final queue = await channel.queue(queueName);

    final consumer = await queue.consume();
    consumer.listen((AmqpMessage message) {
      if (kDebugMode) {
        print("from Queue: $queueName");
       // print(" [x] Received string: ${message.payloadAsString}");
        //print(" [x] Received json: ${message.payloadAsJson}");
        //print(" [x] Received raw: ${message.payload}");
      }

      var notification = jsonDecode(parseJson(message.payloadAsString));
      //Save to local db only if it alert
      if(notification['extras']['type'] == 'alert') {
        //Parse date to timestamp (UTC)
        DateFormat dateFormat = DateFormat("EEE MMM d HH:mm:ss 'UTC' yyyy");
        DateTime dateTime = dateFormat.parseUtc(notification["extras"]["createdAt"]);
        int timestamp = dateTime.millisecondsSinceEpoch;

        final box = Hive.box<Notification.Notification>('notifications');
        box.add(Notification.Notification(title: notification['title'], body:
        notification['body'], createdAt: timestamp, notificationId: int.parse
          (notification['extras']['notificationId'])));
      }

      //Show notification
      showNotification(notification['title'], notification['body'], parseJson(message.payloadAsString));
      message.ack();
    });
  }

  Future<void> addAndConsumeTopic(Channel channel, String topicName, String queueName) async {
    final exchange = await channel.exchange(topicName, ExchangeType.TOPIC);
    final topicQueue = await channel.queue(queueName);

    await topicQueue.bind(exchange, "$topicName.*");

    final consumer = await topicQueue.consume();
    consumer.listen((AmqpMessage message) {
      if (kDebugMode) {
        print("from Topic: $topicName");
        print(" [x] Received string: ${message.payloadAsString}");
        print(" [x] Received json: ${message.payloadAsJson}");
        print(" [x] Received raw: ${message.payload}");
      }

      message.ack();
    });
  }


}