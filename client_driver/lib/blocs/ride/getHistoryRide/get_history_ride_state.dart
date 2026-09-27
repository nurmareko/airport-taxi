part of 'get_history_ride_bloc.dart';

@immutable
sealed class GetHistoryRideState {}

final class RideInitial extends GetHistoryRideState {}

// handling CurrentRide

final class GetHistoryRideLoading extends GetHistoryRideState {}

final class GetHistoryRideFailure extends GetHistoryRideState {
  final String errorMessage;

  GetHistoryRideFailure({required this.errorMessage});
}

final class GetHistoryRideLoaded extends GetHistoryRideState {
  final GetHistoryRideResponseModel model;

  GetHistoryRideLoaded({required this.model});
}
