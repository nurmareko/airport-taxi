import 'package:client_driver/data/dataSources/accept_orderan_api_data.dart';
import 'package:client_driver/data/models/request/accept_orderan_request_model.dart';
import 'package:client_driver/data/models/response/accept_orderan_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'accept_orderan_event.dart';
part 'accept_orderan_state.dart';

class AcceptOrderanBloc extends Bloc<AcceptOrderanEvent, AcceptOrderanState> {
  final AcceptOrderanAPIData datasource;
  AcceptOrderanBloc(this.datasource)
      : super(
          AcceptOrderanInitial(),
        ) {
    on<LoadAcceptOrderanEvent>((event, emit) async {
      emit(AcceptOrderanLoading());
      try {
        final result = await datasource.acceptOrderan(event.request);
        emit(AcceptOrderanSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(AcceptOrderanFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(AcceptOrderanFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
