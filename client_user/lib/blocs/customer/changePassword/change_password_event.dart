part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordEvent {}

class SubmitChangePasswordEvent extends ChangePasswordEvent {
  final ChangePasswordRequestModel request;

  SubmitChangePasswordEvent({required this.request});
}