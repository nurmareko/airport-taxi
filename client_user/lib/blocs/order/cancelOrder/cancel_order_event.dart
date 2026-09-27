part of 'cancel_order_bloc.dart';

@immutable
sealed class CancelOrderEvent {}

class LoadCancelOrderEvent extends CancelOrderEvent {
  final CancelOrderRequestModel request;

  LoadCancelOrderEvent({required this.request});
}
