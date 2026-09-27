part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginFailure extends LoginState {
  final String errorMessage;
  final String? email;

  LoginFailure({required this.errorMessage, this.email});
}

final class LoginSuccess extends LoginState {
  final LoginResponseModel model;
  LoginSuccess({required this.model});
}
