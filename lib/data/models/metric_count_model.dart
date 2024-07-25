import 'package:visionapp/domain/entities/metric_count.dart';

class MetricCountModel extends MetricCount {
  MetricCountModel({required super.count, required super.type});

  factory MetricCountModel.fromJson(Map<String, dynamic> json) {
    return MetricCountModel(
      count: json['count'] as int,
      type: json['type'] as String,
    );
  }



}