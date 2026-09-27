part of 'complete_and_close_ride_bloc.dart';

@immutable
sealed class CompleteAndCloseRideState {}

final class CompleteAndCloseRideInitial extends CompleteAndCloseRideState {}

// handling CurrentRide

final class CompleteAndCloseRideLoading extends CompleteAndCloseRideState {}

final class CompleteAndCloseRideFailure extends CompleteAndCloseRideState {
  final String errorMessage;

  CompleteAndCloseRideFailure({required this.errorMessage, String? email});
}

final class CompleteAndCloseRideSuccess extends CompleteAndCloseRideState {
  final CompleteAndCloseRideResponseModel model;

  CompleteAndCloseRideSuccess({required this.model});
}
