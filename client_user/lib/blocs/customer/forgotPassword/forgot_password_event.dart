part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}

class SubmitForgotPasswordEvent extends ForgotPasswordEvent {
  final ForgotPasswordRequestModel request;

  SubmitForgotPasswordEvent({
    required this.request
  });
}