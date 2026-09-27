part of 'get_current_order_bloc.dart';

@immutable
sealed class GetCurrentOrderState {}

final class GetCurrentOrderInitial extends GetCurrentOrderState {}

// handling get taxis within radius

final class GetCurrentOrderLoading extends GetCurrentOrderState {}

final class GetCurrentOrderFailure extends GetCurrentOrderState {
  final String errorMessage;

  GetCurrentOrderFailure({required this.errorMessage});
}

final class GetCurrentOrderLoaded extends GetCurrentOrderState {
  final GetCurrentOrderResponseModel model;

  GetCurrentOrderLoaded({required this.model});
}
