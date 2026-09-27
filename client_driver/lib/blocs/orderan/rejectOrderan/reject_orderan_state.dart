part of 'reject_orderan_bloc.dart';

@immutable
sealed class RejectOrderanState {}

final class RejectOrderanInitial extends RejectOrderanState {}

// handling CurrentRide

final class RejectOrderanLoading extends RejectOrderanState {}

final class RejectOrderanFailure extends RejectOrderanState {
  final String errorMessage;

  RejectOrderanFailure({required this.errorMessage, String? email});
}

final class RejectOrderanSuccess extends RejectOrderanState {
  final RejectOrderanResponseModel model;

  RejectOrderanSuccess({required this.model});
}
