part of 'verification_email_forgot_password_bloc.dart';

@immutable
sealed class VerificationEmailForgotPasswordEvent {}

class SubmitVerificationEmailForgotPasswordEvent
    extends VerificationEmailForgotPasswordEvent {
  final VerificationEmailForgotPasswordRequestModel request;

  SubmitVerificationEmailForgotPasswordEvent({required this.request});
}

class PressedResendOTPEmailForgotPasswordEvent
    extends VerificationEmailForgotPasswordEvent {
  final ResendOTPEmailForgotPasswordRequestModel request;
  PressedResendOTPEmailForgotPasswordEvent({
    required this.request,
  });
}
