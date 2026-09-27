part of 'update_device_token_bloc.dart';

@immutable
sealed class UpdateDeviceTokenEvent {}

class LoadUpdateDeviceTokenEvent extends UpdateDeviceTokenEvent {
  final UpdateDeviceTokenRequestModel request;

  LoadUpdateDeviceTokenEvent({required this.request});
}
