part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class SubmitLoginEvent extends LoginEvent {
  final LoginRequestModel request;

  SubmitLoginEvent({required this.request});
}
