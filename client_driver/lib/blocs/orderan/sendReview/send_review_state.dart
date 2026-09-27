part of 'send_review_bloc.dart';

@immutable
sealed class SendReviewState {}

final class SendReviewInitial extends SendReviewState {}

// handling CurrentRide

final class SendReviewLoading extends SendReviewState {}

final class SendReviewFailure extends SendReviewState {
  final String errorMessage;

  SendReviewFailure({required this.errorMessage, String? email});
}

final class SendReviewSuccess extends SendReviewState {
  final SendReviewResponseModel model;

  SendReviewSuccess({required this.model});
}
