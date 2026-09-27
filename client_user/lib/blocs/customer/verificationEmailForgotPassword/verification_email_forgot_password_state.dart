part of 'verification_email_forgot_password_bloc.dart';

@immutable
sealed class VerificationEmailForgotPasswordState {}

final class VerificationEmailForgotPasswordInitial
    extends VerificationEmailForgotPasswordState {}

final class VerificationEmailForgotPasswordLoading
    extends VerificationEmailForgotPasswordState {}

final class VerificationEmailForgotPasswordFailure
    extends VerificationEmailForgotPasswordState {
  final String errorMessage;
  final String? email;

  VerificationEmailForgotPasswordFailure(
      {required this.errorMessage, this.email});
}

final class VerificationEmailForgotPasswordSuccess
    extends VerificationEmailForgotPasswordState {
  final VerificationEmailForgotPasswordResponseModel model;

  VerificationEmailForgotPasswordSuccess({required this.model});
}

// handle resend OTP code

final class ResendOTPEmailForgotPasswordLoading extends VerificationEmailForgotPasswordState {}

final class ResendOTPEmailForgotPasswordFailure extends VerificationEmailForgotPasswordState {
  final String errorMessage;
  final String? email;

  ResendOTPEmailForgotPasswordFailure({required this.errorMessage, this.email});
}

final class ResendOTPEmailForgotPasswordSuccess extends VerificationEmailForgotPasswordState {
  final ResendOTPEmailForgotPasswordResponseModel model;

  ResendOTPEmailForgotPasswordSuccess({required this.model});
}
