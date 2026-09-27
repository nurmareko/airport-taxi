part of 'get_taxis_within_radius_bloc.dart';

@immutable
sealed class GetTaxisWithinRadiusState {}

final class GetTaxisWithinRadiusInitial extends GetTaxisWithinRadiusState {}

// handling get taxis within radius

final class GetTaxisWithinRadiusLoading extends GetTaxisWithinRadiusState {}

final class GetTaxisWithinRadiusFailure extends GetTaxisWithinRadiusState {
  final String errorMessage;

  GetTaxisWithinRadiusFailure({required this.errorMessage});
}

final class GetTaxisWithinRadiusLoaded extends GetTaxisWithinRadiusState {
  final GetTaxisWithinRadiusResponseModel model;

  GetTaxisWithinRadiusLoaded({required this.model});
}
