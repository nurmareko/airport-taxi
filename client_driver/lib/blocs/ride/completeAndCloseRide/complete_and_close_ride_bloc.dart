import 'package:client_driver/data/dataSources/complete_and_close_ride_api_data.dart';
import 'package:client_driver/data/models/request/complete_and_close_ride_request_model.dart';
import 'package:client_driver/data/models/response/complete_and_close_ride_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'complete_and_close_ride_event.dart';
part 'complete_and_close_ride_state.dart';

class CompleteAndCloseRideBloc
    extends Bloc<CompleteAndCloseRideEvent, CompleteAndCloseRideState> {
  final CompleteAndCloseRideAPIData datasource;
  CompleteAndCloseRideBloc(this.datasource)
      : super(
          CompleteAndCloseRideInitial(),
        ) {
    on<LoadCompleteAndCloseRideEvent>((event, emit) async {
      emit(CompleteAndCloseRideLoading());
      try {
        final result = await datasource.completeAndCloseRide(event.request);
        emit(CompleteAndCloseRideSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(CompleteAndCloseRideFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(CompleteAndCloseRideFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
