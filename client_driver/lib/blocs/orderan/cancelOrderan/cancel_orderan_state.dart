part of 'cancel_orderan_bloc.dart';

@immutable
sealed class CancelOrderanState {}

final class CancelOrderanInitial extends CancelOrderanState {}

// handling CurrentRide

final class CancelOrderanLoading extends CancelOrderanState {}

final class CancelOrderanFailure extends CancelOrderanState {
  final String errorMessage;

  CancelOrderanFailure({required this.errorMessage, String? email});
}

final class CancelOrderanSuccess extends CancelOrderanState {
  final CancelOrderanResponseModel model;

  CancelOrderanSuccess({required this.model});
}
