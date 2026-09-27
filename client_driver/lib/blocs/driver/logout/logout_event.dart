part of 'logout_bloc.dart';

@immutable
sealed class LogoutEvent {}

class PressedLogoutEvent extends LogoutEvent {}
