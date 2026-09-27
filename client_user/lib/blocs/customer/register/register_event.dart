part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class SubmitRegisterEvent extends RegisterEvent {
  final RegisterRequestModel request;

  SubmitRegisterEvent({
    required this.request
  });
}

class PressedResendOTPEmailRegisterEvent extends RegisterEvent  {
  final ResendOTPEmailRegisterRequestModel request;
  PressedResendOTPEmailRegisterEvent({
    required this.request,
  });
}

