part of 'update_location_bloc.dart';

@immutable
sealed class UpdateLocationState {}

final class UpdateLocationInitial extends UpdateLocationState {}

final class UpdateLocationLoading extends UpdateLocationState {}

final class UpdateLocationFailure extends UpdateLocationState {
  final String errorMessage;
  final String? email;

  UpdateLocationFailure({required this.errorMessage, this.email});
}

final class UpdateLocationSuccess extends UpdateLocationState {
  final UpdateLocationResponseModel model;

  UpdateLocationSuccess({required this.model});
}
