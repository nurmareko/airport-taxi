part of 'add_ride_bloc.dart';

@immutable
sealed class AddRideEvent {}

class LoadAddRideEvent extends AddRideEvent {
  final AddRideRequestModel request;

  LoadAddRideEvent({required this.request});
}
