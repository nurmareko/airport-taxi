part of 'verification_email_register_bloc.dart';

@immutable
sealed class VerificationEmailRegisterState {}

// handle verification email state

final class VerificationEmailRegisterInitial
    extends VerificationEmailRegisterState {}

final class VerificationEmailRegisterLoading
    extends VerificationEmailRegisterState {}

final class VerificationEmailRegisterFailure
    extends VerificationEmailRegisterState {
  final String errorMessage;
  final String? email;

  VerificationEmailRegisterFailure({required this.errorMessage, this.email});
}

final class VerificationEmailRegisterSuccess
    extends VerificationEmailRegisterState {
  final VerificationEmailRegisterResponseModel model;
  VerificationEmailRegisterSuccess({required this.model});
}

// handle resend OTP code

final class ResendOTPEmailRegisterLoading
    extends VerificationEmailRegisterState {}

final class ResendOTPEmailRegisterFailure
    extends VerificationEmailRegisterState {
  final String errorMessage;
  final String? email;

  ResendOTPEmailRegisterFailure({required this.errorMessage, this.email});
}

final class ResendOTPEmailRegisterSuccess
    extends VerificationEmailRegisterState {
  final ResendOTPEmailRegisterResponseModel model;

  ResendOTPEmailRegisterSuccess({required this.model});
}
