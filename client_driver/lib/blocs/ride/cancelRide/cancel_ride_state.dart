part of 'cancel_ride_bloc.dart';

@immutable
sealed class CancelRideState {}

final class CancelRideInitial extends CancelRideState {}

// handling CurrentRide

final class CancelRideLoading extends CancelRideState {}

final class CancelRideFailure extends CancelRideState {
  final String errorMessage;

  CancelRideFailure({required this.errorMessage, String? email});
}

final class CancelRideSuccess extends CancelRideState {
  final CancelRideResponseModel model;

  CancelRideSuccess({required this.model});
}
