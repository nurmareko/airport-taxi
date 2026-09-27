part of 'update_location_bloc.dart';

@immutable
sealed class UpdateLocationEvent {}

class LoadUpdateLocationEvent extends UpdateLocationEvent {
  final UpdateLocationRequestModel request;

  LoadUpdateLocationEvent({required this.request});
}