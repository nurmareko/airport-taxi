import 'package:client_driver/data/dataSources/complete_ride_api_data.dart';
import 'package:client_driver/data/models/request/complete_ride_request_model.dart';
import 'package:client_driver/data/models/response/complete_ride_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'complete_ride_event.dart';
part 'complete_ride_state.dart';

class CompleteRideBloc extends Bloc<CompleteRideEvent, CompleteRideState> {
  final CompleteRideAPIData datasource;
  CompleteRideBloc(this.datasource)
      : super(
          CompleteRideInitial(),
        ) {
    on<LoadCompleteRideEvent>((event, emit) async {
      emit(CompleteRideLoading());
      try {
        final result = await datasource.completeRide(event.request);
        emit(CompleteRideSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(CompleteRideFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(CompleteRideFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
