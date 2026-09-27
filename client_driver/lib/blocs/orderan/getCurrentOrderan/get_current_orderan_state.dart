part of 'get_current_orderan_bloc.dart';

@immutable
sealed class GetCurrentOrderanState {}

final class RideInitial extends GetCurrentOrderanState {}

// handling CurrentRide

final class GetCurrentOrderanLoading extends GetCurrentOrderanState {}

final class GetCurrentOrderanFailure extends GetCurrentOrderanState {
  final String errorMessage;

  GetCurrentOrderanFailure({required this.errorMessage});
}

final class GetCurrentOrderanLoaded extends GetCurrentOrderanState {
  final GetCurrentOrderanResponseModel model;

  GetCurrentOrderanLoaded({required this.model});
}
