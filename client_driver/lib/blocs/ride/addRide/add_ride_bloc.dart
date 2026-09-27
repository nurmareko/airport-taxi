import 'package:airport_taxi_sharing_driver_client/data/dataSources/add_ride_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/dataSources/get_current_ride_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/add_ride_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/add_ride_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/get_current_ride_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_ride_event.dart';
part 'add_ride_state.dart';

class AddRideBloc extends Bloc<AddRideEvent, AddRideState> {
  final AddRideAPIData datasource;
  AddRideBloc(this.datasource)
      : super(
          AddRideInitial(),
        ) {
    on<LoadAddRideEvent>((event, emit) async {
      emit(AddRideLoading());
      try {
        final result = await datasource.addRide(event.request);
        emit(AddRideSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(AddRideFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(AddRideFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
