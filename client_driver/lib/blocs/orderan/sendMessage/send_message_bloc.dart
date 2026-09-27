import 'package:airport_taxi_sharing_driver_client/data/dataSources/send_message_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/send_message_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/send_message_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final SendMessageAPIData datasource;
  SendMessageBloc(this.datasource)
      : super(
          SendMessageInitial(),
        ) {
    on<LoadSendMessageEvent>((event, emit) async {
      emit(SendMessageLoading());
      try {
        final result = await datasource.sendMessage(event.request);
        emit(SendMessageSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(SendMessageFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(SendMessageFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
