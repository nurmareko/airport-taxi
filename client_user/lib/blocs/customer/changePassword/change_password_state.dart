part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordLoading extends ChangePasswordState {}

final class ChangePasswordFailure extends ChangePasswordState {
  final String errorMessage;
  final String? email;

  ChangePasswordFailure({required this.errorMessage, this.email});
}

final class ChangePasswordSuccess extends ChangePasswordState {
  final ChangePasswordResponseModel model;

  ChangePasswordSuccess({required this.model});
}
