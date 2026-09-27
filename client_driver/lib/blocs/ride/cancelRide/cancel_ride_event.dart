part of 'cancel_ride_bloc.dart';

@immutable
sealed class CancelRideEvent {}

class LoadCancelRideEvent extends CancelRideEvent {
  final CancelRideRequestModel request;

  LoadCancelRideEvent({required this.request});
}
