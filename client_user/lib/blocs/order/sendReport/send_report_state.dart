part of 'send_report_bloc.dart';

@immutable
sealed class SendReportState {}

final class SendReportInitial extends SendReportState {}

// handling CurrentRide

final class SendReportLoading extends SendReportState {}

final class SendReportFailure extends SendReportState {
  final String errorMessage;

  SendReportFailure({required this.errorMessage, String? email});
}

final class SendReportSuccess extends SendReportState {
  final SendReportResponseModel model;

  SendReportSuccess({required this.model});
}
