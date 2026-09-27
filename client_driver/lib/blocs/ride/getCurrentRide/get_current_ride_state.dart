part of 'get_current_ride_bloc.dart';

@immutable
sealed class GetCurrentRideState {}

final class RideInitial extends GetCurrentRideState {}

// handling CurrentRide

final class GetCurrentRideLoading extends GetCurrentRideState {}

final class GetCurrentRideFailure extends GetCurrentRideState {
  final String errorMessage;

  GetCurrentRideFailure({required this.errorMessage});
}

final class GetCurrentRideLoaded extends GetCurrentRideState {
  final GetCurrentRideResponseModel model;

  GetCurrentRideLoaded({required this.model});
}
