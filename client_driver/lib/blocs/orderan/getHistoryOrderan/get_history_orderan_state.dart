part of 'get_history_orderan_bloc.dart';

@immutable
sealed class GetHistoryOrderanState {}

final class RideInitial extends GetHistoryOrderanState {}

// handling HistoryRide

final class GetHistoryOrderanLoading extends GetHistoryOrderanState {}

final class GetHistoryOrderanFailure extends GetHistoryOrderanState {
  final String errorMessage;

  GetHistoryOrderanFailure({required this.errorMessage});
}

final class GetHistoryOrderanLoaded extends GetHistoryOrderanState {
  final GetHistoryOrderanResponseModel model;

  GetHistoryOrderanLoaded({required this.model});
}
