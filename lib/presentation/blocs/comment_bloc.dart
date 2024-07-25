import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/utils/shared_prefs.dart';
import 'package:visionapp/core/utils/text_util.dart';
import 'package:visionapp/data/models/comment_model.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/usecases/home/comments/post_comments.dart';
import 'package:visionapp/features/services/amqp_client.dart';

const kReceiveCommentsQueue = '20Vision.CommentsReceiveQueue';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentError extends CommentState {
  final String message;

  CommentError({required this.message});
}

final class CommentListFetched extends CommentState {
  final List<Comment> comments;
  final bool shouldNotify;
  CommentListFetched({required this.comments, required this.shouldNotify});
}

@immutable
sealed class CommentEvent {}

final class SubscribeToQueue extends CommentEvent {}

final class FetchComment extends CommentEvent {
  final int postId;

  FetchComment({required this.postId});
}

final class QueueMessageReceived extends CommentEvent {
  final List<Comment> comments;
  QueueMessageReceived({required this.comments});
}

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostComments _postComments;
  final SharedPrefs _sharedPrefs;
  final AmqpClient _amqpClient;

  CommentBloc(
      {required PostComments postComments,
      required SharedPrefs sharedPrefs,
      required AmqpClient amqpClient
     })
      : _postComments = postComments,
        _sharedPrefs = sharedPrefs,
        _amqpClient = amqpClient,
        super(CommentInitial()) {
    on<CommentEvent>((event, emit) => emit(CommentLoading()));
    on<FetchComment>(_fetchComment);
    on<SubscribeToQueue>(_subscribeToCommentQueue);
    on<QueueMessageReceived>(_queueMessageReceived);
  }

  _subscribeToCommentQueue(SubscribeToQueue event, Emitter<CommentState> emit) {
    _sharedPrefs.get("deviceId").then((deviceId) {
      final queueName = "metric-comments-queue-$deviceId";
      _amqpClient.client.channel().then((Channel channel) {
        return channel
            .exchange(kReceiveCommentsQueue, ExchangeType.TOPIC, durable: true)
            .then((Exchange exchange) {
          return channel.queue(queueName).then((Queue queue) {
            return queue.bind(exchange, "$kReceiveCommentsQueue.*").then((_) {
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

          List<dynamic> payload =
          jsonDecode(parseJson(message.payloadAsString));
          List<Comment> comments = payload
              .map((comment) => CommentModel.fromJson(comment))
              .toList();
          add(QueueMessageReceived(comments: comments));

          //emit(CommentListFetched(comments: comments, shouldNotify: true));
        });
      });
    });
  }

  _fetchComment(FetchComment event, Emitter<CommentState> emit) async {
    final result = await _postComments.call(PostCommentsParams(event.postId));
    result.fold(
      (failure) => emit(CommentError(message: failure.message)),
      (comments) => emit(CommentListFetched(comments: comments, shouldNotify: false)),
    );
  }
  _queueMessageReceived(QueueMessageReceived event, Emitter<CommentState> emit) {
    print("QueueMessageReceived");
    emit(CommentListFetched(comments: event.comments, shouldNotify: true));

  }
}
