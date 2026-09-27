part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent {}

class SubmitResetPasswordEvent extends ResetPasswordEvent {
  final ResetPasswordRequestModel request;

  SubmitResetPasswordEvent({required this.request});
}

