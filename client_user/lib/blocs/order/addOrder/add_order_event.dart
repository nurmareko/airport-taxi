part of 'add_order_bloc.dart';

@immutable
sealed class AddOrderEvent {}

class SubmitAddOrderEvent extends AddOrderEvent {
  final AddOrderRequestModel request;

  SubmitAddOrderEvent({
    required this.request
  });
}