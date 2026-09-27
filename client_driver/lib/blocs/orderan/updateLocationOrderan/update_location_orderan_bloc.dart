
import 'package:airport_taxi_sharing_driver_client/data/dataSources/update_location_orderan_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_location_orderan_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/update_Location_orderan_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_location_orderan_event.dart';
part 'update_location_orderan_state.dart';

class UpdateLocationOrderanBloc
    extends Bloc<UpdateLocationOrderanEvent, UpdateLocationOrderanState> {
  final UpdateLocationOrderanAPIData datasource;
  UpdateLocationOrderanBloc(this.datasource)
      : super(
          UpdateLocationOrderanInitial(),
        ) {
    on<LoadUpdateLocationOrderanEvent>((event, emit) async {
      emit(UpdateLocationOrderanLoading());
      try {
        final result = await datasource.updateLocationOrderan(event.request);
        emit(UpdateLocationOrderanSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(UpdateLocationOrderanFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(UpdateLocationOrderanFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
