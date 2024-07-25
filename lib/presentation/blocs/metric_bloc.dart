import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/utils/shared_prefs.dart';
import 'package:visionapp/core/utils/text_util.dart';
import 'package:visionapp/data/models/metric_count_model.dart';
import 'package:visionapp/domain/entities/metric_count.dart';
import 'package:visionapp/domain/enums/metric_type.dart';
import 'package:visionapp/domain/usecases/home/posts/get_metrics_for_post.dart';
import 'package:visionapp/domain/usecases/metrics/add_metric.dart';
import 'package:visionapp/features/services/amqp_client.dart';

const kReceiveMetricQueue = '20Vision.MetricReceiveQueue';
const kSendMetricQueue = '20Vision.SendMetricQueue';

@immutable
sealed class MetricState {}

final class MetricInitial extends MetricState {}

final class MetricReceived extends MetricState {
  final List<MetricCount> metrics;
  final bool shouldNotify;

  MetricReceived(this.metrics, this.shouldNotify);
}

final class MetricReceivedError extends MetricState {
  final String message;

  MetricReceivedError(this.message);
}

final class MetricAdded extends MetricState {}

@immutable
sealed class MetricEvent {}

final class ReceiveMetric extends MetricEvent {
  final List<MetricCount> metrics;
  final bool shouldNotify;

  ReceiveMetric(this.metrics, this.shouldNotify);
}

final class PostMetric extends MetricEvent {
  final Map<String, dynamic> metrics;

  PostMetric(this.metrics);
}

final class GetPostMetric extends MetricEvent {
  final int postId;
  GetPostMetric(this.postId);
}


final class AddMetricEvent extends MetricEvent {
  final int userId;
  final int postId;
  final MetricType type;
  final String value;

  AddMetricEvent(this.userId, this.postId, this.type, this.value);
}

final class ReceiveMetricError extends MetricEvent {
  final String message;

  ReceiveMetricError(this.message);
}

final class BindMetricReading extends MetricEvent {}


class MetricBloc extends Bloc<MetricEvent, MetricState> {
  final AmqpClient _amqpClient;
  final SharedPrefs _sharedPrefs;
  final GetMetricsForPost _getMetricsForPost;
  final AddMetric _addMetric;

  MetricBloc({
    required AmqpClient amqpClient,
    required SharedPrefs sharedPrefs,
    required GetMetricsForPost getMetricsForPost,
    required AddMetric addMetric,
  })  : _amqpClient = amqpClient,
        _sharedPrefs = sharedPrefs,
        _getMetricsForPost = getMetricsForPost,
        _addMetric = addMetric,
        super(MetricInitial()) {
    on<ReceiveMetric>((event, emit) => emit(MetricReceived(event.metrics,
        event.shouldNotify)));
    on<PostMetric>(_postMetrics);
    on<ReceiveMetricError>((event, emit) => emit(MetricReceivedError(event.message)));
    on<BindMetricReading>((event, emit) => _subscribeToMetricQueue());
    on<GetPostMetric>(_onGetPostMetric);
    on<AddMetricEvent>(_onAddMetric);
  }
  _onAddMetric(AddMetricEvent event, Emitter<MetricState> emit) async {
    print("This is npt triggering");
    final result = await _addMetric.call(AddMetricParams(
        userId:event.userId,
        postId: event.postId,
        type: event.type,
        value: event.value)
    );
    result.fold(
          (failure) => emit(MetricReceivedError(failure.message)),
          (success) => emit(MetricAdded()),
    );
  }
  _onGetPostMetric(GetPostMetric event, Emitter<MetricState> emit) async {
    final result =  await _getMetricsForPost.call(GetMetricsForPostParams(event
        .postId));
    result.fold(
          (failure) => emit(MetricReceivedError(failure.message)),
          (metrics) => emit(MetricReceived(metrics,false)),
    );
  }

  _subscribeToMetricQueue() {
    _sharedPrefs.get("deviceId").then((deviceId) {
      final queueName = "metric-count-queue-$deviceId";
      //Receiving Message
      _amqpClient.client.channel().then((Channel channel) {
        return channel
            .exchange(kReceiveMetricQueue, ExchangeType.TOPIC, durable: true)
            .then((Exchange exchange) {
          return channel.queue(queueName).then((Queue queue) {
            return queue.bind(exchange, "$kReceiveMetricQueue.*").then((_) {
              return queue.consume();
            });
          });
        });
      }).then((Consumer consumer) {
        consumer.listen((AmqpMessage message) {
          if (kDebugMode) {
            print(
                "Consumer ${consumer.tag} received: ${message.payloadAsString}");
          }

          List<dynamic> payload = jsonDecode(parseJson(message
              .payloadAsString));
          if((payload[0] as Map<dynamic,dynamic>).containsKey("error")){
            add(ReceiveMetricError((payload[0] as Map<dynamic,dynamic>)["error"]));
            return;
          }
          List<MetricCount> metrics = payload.map((e) => MetricCountModel.fromJson(e)).toList();
          add(ReceiveMetric(metrics, true));

        });
      });
    });
  }

  _postMetrics(PostMetric event, Emitter<MetricState> emit) {

    _amqpClient.client.channel().then((Channel channel) {
      return channel
          .exchange(kSendMetricQueue, ExchangeType.TOPIC, durable: true)
          .then((Exchange exchange) {
        print(jsonEncode(event.metrics));
        return exchange.publish(event.metrics, "$kSendMetricQueue.*");
      });
    }).then((_) {
      print("Message published successfully");
    }).catchError((error) {
      print("Failed to publish message: $error");
    });;
  }
}
