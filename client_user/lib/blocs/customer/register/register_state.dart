part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

// handle register

final class RegisterLoading extends RegisterState {}

final class RegisterFailure extends RegisterState {
  final String errorMessage;
  final String? email;

  RegisterFailure({required this.errorMessage, this.email});
}

final class RegisterSuccess extends RegisterState {
  final RegisterResponseModel model;
  RegisterSuccess({required this.model});
}

// handle resend OTP

final class ResendOTPEmailRegisterLoading extends RegisterState {}

final class ResendOTPEmailRegisterFailure extends RegisterState {
  final String errorMessage;
  final String? email;

  ResendOTPEmailRegisterFailure({required this.errorMessage, this.email});
}

final class ResendOTPEmailRegisterSuccess extends RegisterState {
  final ResendOTPEmailRegisterResponseModel model;

  ResendOTPEmailRegisterSuccess({required this.model});
}
