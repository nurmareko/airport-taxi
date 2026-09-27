part of 'send_message_bloc.dart';

@immutable
sealed class SendMessageEvent {}

class LoadSendMessageEvent extends SendMessageEvent {
  final SendMessageRequestModel request;

  LoadSendMessageEvent({required this.request});
}
