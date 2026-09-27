part of 'get_driver_bloc.dart';

@immutable
sealed class GetDriverState {}

final class GetDriverInitial extends GetDriverState {}

// handling Driver fetching

final class GetDriverLoading extends GetDriverState {}

final class GetDriverFailure extends GetDriverState {
  final String errorMessage;

  GetDriverFailure({required this.errorMessage});
}

final class GetDriverLoaded extends GetDriverState {
  final GetDriverResponseModel model;

  GetDriverLoaded({required this.model});
}
