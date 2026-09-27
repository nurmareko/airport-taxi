import 'package:airport_taxi_sharing_driver_client/data/dataSources/cancel_orderan_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/Cancel_orderan_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/Cancel_orderan_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cancel_orderan_event.dart';
part 'cancel_orderan_state.dart';

class CancelOrderanBloc extends Bloc<CancelOrderanEvent, CancelOrderanState> {
  final CancelOrderanAPIData datasource;
  CancelOrderanBloc(this.datasource)
      : super(
          CancelOrderanInitial(),
        ) {
    on<LoadCancelOrderanEvent>((event, emit) async {
      emit(CancelOrderanLoading());
      try {
        final result = await datasource.cancelOrderan(event.request);
        emit(CancelOrderanSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(CancelOrderanFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(CancelOrderanFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
