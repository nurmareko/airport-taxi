import 'package:airport_taxi_sharing_driver_client/data/dataSources/cancel_ride_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/cancel_ride_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/cancel_ride_response_model.dart';

import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cancel_ride_event.dart';
part 'cancel_ride_state.dart';

class CancelRideBloc extends Bloc<CancelRideEvent, CancelRideState> {
  final CancelRideAPIData datasource;
  CancelRideBloc(this.datasource)
      : super(
          CancelRideInitial(),
        ) {
    on<LoadCancelRideEvent>((event, emit) async {
      emit(CancelRideLoading());
      try {
        final result = await datasource.cancelRide(event.request);
        emit(CancelRideSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(CancelRideFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(CancelRideFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
