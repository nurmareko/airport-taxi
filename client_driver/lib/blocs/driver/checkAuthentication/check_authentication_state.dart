part of 'check_authentication_bloc.dart';

@immutable
sealed class CheckAuthenticationState {}

final class CheckAuthenticationInitial extends CheckAuthenticationState {}

final class CheckAuthenticationAuthenticated extends CheckAuthenticationState {
  final CheckAuthenticationResponseModel model;
  CheckAuthenticationAuthenticated({required this.model});
}

final class CheckAuthenticationUnauthenticated
    extends CheckAuthenticationState {
  final String errorMessage;

  CheckAuthenticationUnauthenticated({
    required this.errorMessage,
  });
}

final class CheckAuthenticationLoading extends CheckAuthenticationState {}
