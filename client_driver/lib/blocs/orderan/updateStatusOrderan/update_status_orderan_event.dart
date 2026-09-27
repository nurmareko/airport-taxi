part of 'update_status_orderan_bloc.dart';

@immutable
sealed class UpdateStatusOrderanEvent {}

class LoadUpdateStatusOrderanEvent extends UpdateStatusOrderanEvent {
  final UpdateStatusOrderanRequestModel request;

  LoadUpdateStatusOrderanEvent({required this.request});
}
