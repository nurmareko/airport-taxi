part of 'get_history_order_bloc.dart';

@immutable
sealed class GetHistoryOrderState {}

final class GetHistoryOrderInitial extends GetHistoryOrderState {}

// handling get taxis within radius

final class GetHistoryOrderLoading extends GetHistoryOrderState {}

final class GetHistoryOrderFailure extends GetHistoryOrderState {
  final String errorMessage;

  GetHistoryOrderFailure({required this.errorMessage});
}

final class GetHistoryOrderLoaded extends GetHistoryOrderState {
  final GetHistoryOrderResponseModel model;

  GetHistoryOrderLoaded({required this.model});
}
