part of 'accept_orderan_bloc.dart';

@immutable
sealed class AcceptOrderanEvent {}

class LoadAcceptOrderanEvent extends AcceptOrderanEvent {
  final AcceptOrderanRequestModel request;

  LoadAcceptOrderanEvent({required this.request});
}
