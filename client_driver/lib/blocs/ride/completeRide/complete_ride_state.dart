part of 'complete_ride_bloc.dart';

@immutable
sealed class CompleteRideState {}

final class CompleteRideInitial extends CompleteRideState {}

// handling CurrentRide

final class CompleteRideLoading extends CompleteRideState {}

final class CompleteRideFailure extends CompleteRideState {
  final String errorMessage;

  CompleteRideFailure({required this.errorMessage, String? email});
}

final class CompleteRideSuccess extends CompleteRideState {
  final CompleteRideResponseModel model;

  CompleteRideSuccess({required this.model});
}
