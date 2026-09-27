part of 'reject_orderan_bloc.dart';

@immutable
sealed class RejectOrderanEvent {}

class LoadRejectOrderanEvent extends RejectOrderanEvent {
  final RejectOrderanRequestModel request;

  LoadRejectOrderanEvent({required this.request});
}
