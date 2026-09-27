part of 'send_report_bloc.dart';

@immutable
sealed class SendReportEvent {}

class LoadSendReportEvent extends SendReportEvent {
  final SendReportRequestModel request;

  LoadSendReportEvent({required this.request});
}
