part of 'update_customer_bloc.dart';

@immutable
sealed class UpdateCustomerEvent {}


class SubmitUpdateCustomerEvent extends UpdateCustomerEvent {
  final UpdateCustomerRequestModel request;

  SubmitUpdateCustomerEvent({required this.request});
}