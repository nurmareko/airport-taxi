part of 'update_status_orderan_bloc.dart';

@immutable
sealed class UpdateStatusOrderanState {}

final class UpdateStatusOrderanInitial extends UpdateStatusOrderanState {}

// handling CurrentRide

final class UpdateStatusOrderanLoading extends UpdateStatusOrderanState {}

final class UpdateStatusOrderanFailure extends UpdateStatusOrderanState {
  final String errorMessage;

  UpdateStatusOrderanFailure({required this.errorMessage, String? email});
}

final class UpdateStatusOrderanSuccess extends UpdateStatusOrderanState {
  final UpdateStatusOrderanResponseModel model;

  UpdateStatusOrderanSuccess({required this.model});
}
