part of 'accept_orderan_bloc.dart';

@immutable
sealed class AcceptOrderanState {}

final class AcceptOrderanInitial extends AcceptOrderanState {}

// handling CurrentRide

final class AcceptOrderanLoading extends AcceptOrderanState {}

final class AcceptOrderanFailure extends AcceptOrderanState {
  final String errorMessage;

  AcceptOrderanFailure({required this.errorMessage, String? email});
}

final class AcceptOrderanSuccess extends AcceptOrderanState {
  final AcceptOrderanResponseModel model;

  AcceptOrderanSuccess({required this.model});
}
