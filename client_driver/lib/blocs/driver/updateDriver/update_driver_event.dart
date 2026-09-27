part of 'update_driver_bloc.dart';

@immutable
sealed class UpdateDriverEvent {}

class SubmitUpdateDriverEvent extends UpdateDriverEvent {
  final UpdateDriverRequestModel request;

  SubmitUpdateDriverEvent({required this.request});
}
