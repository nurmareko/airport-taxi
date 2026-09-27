part of 'update_device_token_bloc.dart';

@immutable
sealed class UpdateDeviceTokenState {}

final class UpdateDeviceTokenInitial extends UpdateDeviceTokenState {}

final class UpdateDeviceTokenLoading extends UpdateDeviceTokenState {}

final class UpdateDeviceTokenFailure extends UpdateDeviceTokenState {
  final String errorMessage;
  final String? email;

  UpdateDeviceTokenFailure({required this.errorMessage, this.email});
}

final class UpdateDeviceTokenSuccess extends UpdateDeviceTokenState {
  final UpdateDeviceTokenResponseModel model;

  UpdateDeviceTokenSuccess({required this.model});
}
