part of 'cancel_orderan_bloc.dart';

@immutable
sealed class CancelOrderanEvent {}

class LoadCancelOrderanEvent extends CancelOrderanEvent {
  final CancelOrderanRequestModel request;

  LoadCancelOrderanEvent({required this.request});
}
