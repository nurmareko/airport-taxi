import 'package:airport_taxi_sharing_driver_client/data/dataSources/update_status_orderan_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_status_orderan_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/update_status_orderan_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_status_orderan_event.dart';
part 'update_status_orderan_state.dart';

class UpdateStatusOrderanBloc
    extends Bloc<UpdateStatusOrderanEvent, UpdateStatusOrderanState> {
  final UpdateStatusOrderanAPIData datasource;
  UpdateStatusOrderanBloc(this.datasource)
      : super(
          UpdateStatusOrderanInitial(),
        ) {
    on<LoadUpdateStatusOrderanEvent>((event, emit) async {
      emit(UpdateStatusOrderanLoading());
      try {
        final result = await datasource.updateStatusOrderan(event.request);
        emit(UpdateStatusOrderanSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(UpdateStatusOrderanFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(UpdateStatusOrderanFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
