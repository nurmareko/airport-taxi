part of 'cancel_order_bloc.dart';

@immutable
sealed class CancelOrderState {}

final class CancelOrderInitial extends CancelOrderState {}

final class CancelOrderLoading extends CancelOrderState {}

final class CancelOrderFailure extends CancelOrderState {
  final String errorMessage;
  final String? email;

  CancelOrderFailure({required this.errorMessage, this.email});
}

final class CancelOrderSuccess extends CancelOrderState {
  final CancelOrderResponseModel model;

  CancelOrderSuccess({required this.model});
}
