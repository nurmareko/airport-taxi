part of 'send_review_bloc.dart';

@immutable
sealed class SendReviewEvent {}

class LoadSendReviewEvent extends SendReviewEvent {
  final SendReviewRequestModel request;

  LoadSendReviewEvent({required this.request});
}
