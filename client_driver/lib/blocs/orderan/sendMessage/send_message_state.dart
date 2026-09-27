part of 'send_message_bloc.dart';

@immutable
sealed class SendMessageState {}

final class SendMessageInitial extends SendMessageState {}

// handling CurrentRide

final class SendMessageLoading extends SendMessageState {}

final class SendMessageFailure extends SendMessageState {
  final String errorMessage;

  SendMessageFailure({required this.errorMessage, String? email});
}

final class SendMessageSuccess extends SendMessageState {
  final SendMessageResponseModel model;

  SendMessageSuccess({required this.model});
}
