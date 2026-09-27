part of 'complete_ride_bloc.dart';

@immutable
sealed class CompleteRideEvent {}

class LoadCompleteRideEvent extends CompleteRideEvent {
  final CompleteRideRequestModel request;

  LoadCompleteRideEvent({required this.request});
}
