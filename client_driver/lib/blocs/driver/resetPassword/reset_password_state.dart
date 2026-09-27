part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordFailure extends ResetPasswordState {
  final String errorMessage;
  final String? email;

  ResetPasswordFailure({required this.errorMessage, this.email});
}

final class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponseModel model;

  ResetPasswordSuccess({required this.model});
}
