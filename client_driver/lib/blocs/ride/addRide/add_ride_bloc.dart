import 'package:client_driver/data/dataSources/add_ride_api_data.dart';
import 'package:client_driver/data/models/request/add_ride_request_model.dart';
import 'package:client_driver/data/models/response/add_ride_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
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
