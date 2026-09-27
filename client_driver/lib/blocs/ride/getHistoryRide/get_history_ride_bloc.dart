import 'package:airport_taxi_sharing_driver_client/data/dataSources/get_history_ride_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/get_history_ride_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_history_ride_event.dart';
part 'get_history_ride_state.dart';

class GetHistoryRideBloc
    extends Bloc<GetHistoryRideEvent, GetHistoryRideState> {
  final GetHistoryRideAPIData datasource;

  GetHistoryRideBloc(this.datasource)
      : super(
          RideInitial(),
        ) {
    // Get Current Ride
    on<LoadGetHistoryRideEvent>((event, emit) async {
      emit(GetHistoryRideLoading());
      try {
        final result = await datasource.getHistoryRideData();
        emit(GetHistoryRideLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetHistoryRideFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetHistoryRideFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
