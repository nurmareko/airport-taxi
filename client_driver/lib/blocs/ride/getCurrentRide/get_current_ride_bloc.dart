import 'package:client_driver/data/dataSources/get_current_ride_api_data.dart';
import 'package:client_driver/data/models/response/get_current_ride_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_current_ride_event.dart';
part 'get_current_ride_state.dart';

class GetCurrentRideBloc
    extends Bloc<GetCurrentRideEvent, GetCurrentRideState> {
  final GetCurrentRideAPIData datasource;

  GetCurrentRideBloc(this.datasource)
      : super(
          RideInitial(),
        ) {
    // Get Current Ride
    on<LoadGetCurrentRideEvent>((event, emit) async {
      emit(GetCurrentRideLoading());
      try {
        final result = await datasource.getCurrentRideData();
        emit(GetCurrentRideLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetCurrentRideFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetCurrentRideFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
