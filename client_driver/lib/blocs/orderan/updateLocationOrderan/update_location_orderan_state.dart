part of 'update_location_orderan_bloc.dart';

@immutable
sealed class UpdateLocationOrderanState {}

final class UpdateLocationOrderanInitial extends UpdateLocationOrderanState {}

final class UpdateLocationOrderanLoading extends UpdateLocationOrderanState {}

final class UpdateLocationOrderanFailure extends UpdateLocationOrderanState {
  final String errorMessage;

  UpdateLocationOrderanFailure({required this.errorMessage, String? email});
}

final class UpdateLocationOrderanSuccess extends UpdateLocationOrderanState {
  final UpdateLocationOrderanResponseModel model;

  UpdateLocationOrderanSuccess({required this.model});
}
