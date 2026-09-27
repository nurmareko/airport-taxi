part of 'verification_email_register_bloc.dart';

@immutable
sealed class VerificationEmailRegisterEvent {}

class SubmitVerificationEmailRegisterEvent extends VerificationEmailRegisterEvent {
  final VerificationEmailRegisterRequestModel request;

  SubmitVerificationEmailRegisterEvent({required this.request});
}

class PressedResendOTPEmailRegisterEvent extends VerificationEmailRegisterEvent {
  final ResendOTPEmailRegisterRequestModel request;
  PressedResendOTPEmailRegisterEvent({
    required this.request,
  });
}
