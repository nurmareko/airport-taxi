part of 'complete_and_close_ride_bloc.dart';

@immutable
sealed class CompleteAndCloseRideEvent {}

class LoadCompleteAndCloseRideEvent extends CompleteAndCloseRideEvent {
  final CompleteAndCloseRideRequestModel request;

  LoadCompleteAndCloseRideEvent({required this.request});
}
