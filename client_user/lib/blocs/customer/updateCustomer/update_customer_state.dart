part of 'update_customer_bloc.dart';

@immutable
sealed class UpdateCustomerState {}

final class UpdateCustomerInitial extends UpdateCustomerState {}

final class UpdateCustomerLoading extends UpdateCustomerState {}

final class UpdateCustomerFailure extends UpdateCustomerState {
  final String errorMessage;
  final String? email;

  UpdateCustomerFailure({required this.errorMessage, this.email});
}

final class UpdateCustomerSuccess extends UpdateCustomerState {
  final UpdateCustomerResponseModel model;

  UpdateCustomerSuccess({required this.model});
}
