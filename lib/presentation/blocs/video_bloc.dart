import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
sealed class VideoState {}
final class VideoInitial extends VideoState {}
final class VideoEnded extends VideoState {}

@immutable
sealed class  VideoEvent {}
final class VideoEndNotify extends VideoEvent {}

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoInitial()) {
    on<VideoEvent>((event, emit) {
      if (event is VideoEndNotify) {
        emit(VideoEnded());
      }
    });
  }
}
