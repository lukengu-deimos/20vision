import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/usecases/alert/delete_alert.dart';
import 'package:visionapp/domain/usecases/alert/get_alerts.dart';
import 'package:visionapp/domain/entities/notification.dart' as Notification;
import 'package:visionapp/domain/usecases/alert/update_alerts.dart';

@immutable
sealed class AlertState {}
final class AlertInitial extends AlertState {}
final class AlertLoading extends AlertState {}
final class AlertFetchSuccess extends AlertState {
  final List<Notification.Notification> notifications;
  AlertFetchSuccess(this.notifications);
}
final class AlertFetchFailure extends AlertState {
  final String message;
  AlertFetchFailure(this.message);
}
final class AlertDeleted extends AlertState {
  final bool status;
  AlertDeleted(this.status);
}
@immutable
sealed class AlertEvent {}

final class FetchAlerts extends AlertEvent {}
final class DeleteAlertEvent extends AlertEvent {
  final int id;
  final int userId;
  DeleteAlertEvent(this.id, this.userId);
}
final class UpdateAlertEvent extends AlertEvent {
  final int userId;
  UpdateAlertEvent(this.userId);
}



class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final GetAlerts _getchAlerts;
  final DeleteAlert _deleteAlert;
  final UpdateAlerts _updateAlerts;

  AlertBloc({required GetAlerts getchAlerts, required DeleteAlert
  deleteAlert, required UpdateAlerts updateAlerts }):
        _getchAlerts = getchAlerts,
        _deleteAlert = deleteAlert,
        _updateAlerts = updateAlerts,
       super(AlertInitial()) {
        on<AlertEvent>((event, emit) {
          emit(AlertLoading());
        });

        on<FetchAlerts>(_onFetchAlerts);
        on<DeleteAlertEvent>(_onDeleteAlertEvent);
        on<UpdateAlertEvent>(_onUpdateAlerts);
  }

  _onUpdateAlerts(UpdateAlertEvent event, Emitter<AlertState> emit) async {
    final result = await _updateAlerts.call(UpdateAlertsParams(event.userId));
    result.fold(
      (failure) => emit(AlertFetchFailure(failure.message)),
      (notifications) => emit(AlertFetchSuccess(notifications))
    );
  }

  _onFetchAlerts(FetchAlerts event, Emitter<AlertState> emit) async {
    final result = await _getchAlerts.call(NoParams());
    result.fold(
      (failure) => emit(AlertFetchFailure(failure.message)),
      (notifications) => emit(AlertFetchSuccess(notifications))
    );
  }

  _onDeleteAlertEvent(DeleteAlertEvent event, Emitter<AlertState> emit) async {
    final result = await _deleteAlert.call(DeleteAlertParams(event.id, event
        .userId));
    result.fold(
      (failure) => emit(AlertFetchFailure(failure.message)),
      (notifications) => emit(AlertFetchSuccess(notifications))
    );
  }
}