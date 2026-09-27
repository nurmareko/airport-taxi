part of 'update_driver_bloc.dart';

@immutable
sealed class UpdateDriverState {}

final class UpdateDriverInitial extends UpdateDriverState {}

final class UpdateDriverLoading extends UpdateDriverState {}

final class UpdateDriverFailure extends UpdateDriverState {
  final String errorMessage;
  final String? email;

  UpdateDriverFailure({required this.errorMessage, this.email});
}

final class UpdateDriverSuccess extends UpdateDriverState {
  final UpdateDriverResponseModel model;

  UpdateDriverSuccess({required this.model});
}
