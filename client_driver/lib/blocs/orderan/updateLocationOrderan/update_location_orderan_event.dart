part of 'update_location_orderan_bloc.dart';

@immutable
sealed class UpdateLocationOrderanEvent {}

class LoadUpdateLocationOrderanEvent extends UpdateLocationOrderanEvent {
  final UpdateLocationOrderanRequestModel request;

  LoadUpdateLocationOrderanEvent({required this.request});
}
