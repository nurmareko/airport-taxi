import 'package:airport_taxi_sharing_user_client/data/dataSources/update_location_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/update_location_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/update_location_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_location_event.dart';
part 'update_location_state.dart';

class UpdateLocationBloc extends Bloc<UpdateLocationEvent, UpdateLocationState> {
  final UpdateLocationAPIData datasource;
  UpdateLocationBloc(this.datasource) : super(UpdateLocationInitial()) {
    on<LoadUpdateLocationEvent>((event, emit) async{
       emit(UpdateLocationLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.updateLocation(event.request);
        emit(UpdateLocationSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(UpdateLocationFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(UpdateLocationFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
