part of 'logout_bloc.dart';

@immutable
sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}

// handling customer fetching

final class LogoutLoading extends LogoutState {}

final class LogoutFailure extends LogoutState {
  final String errorMessage;

  LogoutFailure({required this.errorMessage});
}

final class LogoutLoaded extends LogoutState {}
