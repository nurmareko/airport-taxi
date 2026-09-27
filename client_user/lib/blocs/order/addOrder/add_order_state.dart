part of 'add_order_bloc.dart';

@immutable
sealed class AddOrderState {}

final class AddOrderInitial extends AddOrderState {}

final class AddOrderLoading extends AddOrderState {}

final class AddOrderFailure extends AddOrderState {
  final String errorMessage;
  final String? email;

  AddOrderFailure({required this.errorMessage, this.email});
}

final class AddOrderSuccess extends AddOrderState {
  final AddOrderResponseModel model;
  AddOrderSuccess({required this.model});
}
