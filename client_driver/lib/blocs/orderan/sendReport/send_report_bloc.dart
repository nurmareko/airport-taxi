import 'package:client_driver/data/dataSources/send_report_api_data.dart';
import 'package:client_driver/data/models/request/send_report_request_model.dart';
import 'package:client_driver/data/models/response/send_report_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'send_report_event.dart';
part 'send_report_state.dart';

class SendReportBloc extends Bloc<SendReportEvent, SendReportState> {
  final SendReportAPIData datasource;
  SendReportBloc(this.datasource)
      : super(
          SendReportInitial(),
        ) {
    on<LoadSendReportEvent>((event, emit) async {
      emit(SendReportLoading());
      try {
        final result = await datasource.sendReport(event.request);
        emit(SendReportSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(SendReportFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(SendReportFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
