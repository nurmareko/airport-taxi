part of 'get_customer_bloc.dart';

@immutable
sealed class GetCustomerState {}

final class GetCustomerInitial extends GetCustomerState {}


// handling customer fetching 

final class GetCustomerLoading extends GetCustomerState {}

final class GetCustomerFailure extends GetCustomerState {
  final String errorMessage;

  GetCustomerFailure({required this.errorMessage});
}

final class GetCustomerLoaded extends GetCustomerState {
  final GetCustomerResponseModel model;

  GetCustomerLoaded({required this.model});
}