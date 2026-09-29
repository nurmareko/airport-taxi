import 'package:client_driver/data/dataSources/reject_orderan_api_data.dart';
import 'package:client_driver/data/models/request/reject_orderan_request_model.dart';
import 'package:client_driver/data/models/response/reject_orderan_response_model.dart';

import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reject_orderan_event.dart';
part 'reject_orderan_state.dart';

class RejectOrderanBloc extends Bloc<RejectOrderanEvent, RejectOrderanState> {
  final RejectOrderanAPIData datasource;
  RejectOrderanBloc(this.datasource)
      : super(
          RejectOrderanInitial(),
        ) {
    on<LoadRejectOrderanEvent>((event, emit) async {
      emit(RejectOrderanLoading());
      try {
        final result = await datasource.rejectOrderan(event.request);
        emit(RejectOrderanSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(RejectOrderanFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(RejectOrderanFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
