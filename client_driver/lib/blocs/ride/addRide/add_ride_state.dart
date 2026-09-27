part of 'add_ride_bloc.dart';

@immutable
sealed class AddRideState {}

final class AddRideInitial extends AddRideState {}

// handling CurrentRide

final class AddRideLoading extends AddRideState {}

final class AddRideFailure extends AddRideState {
  final String errorMessage;

  AddRideFailure({required this.errorMessage, String? email});
}

final class AddRideSuccess extends AddRideState {
  final AddRideResponseModel model;

  AddRideSuccess({required this.model});
}
