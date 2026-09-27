part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {}

// handling email input

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordFailure extends ForgotPasswordState {
  final String errorMessage;
  final String? email;

  ForgotPasswordFailure({
    required this.errorMessage,
    this.email
  });
}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponseModel model;
  ForgotPasswordSuccess({
    required this.model
  });
}

