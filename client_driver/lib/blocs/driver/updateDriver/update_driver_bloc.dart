import 'package:airport_taxi_sharing_driver_client/data/dataSources/update_driver_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_driver_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/update_driver_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_driver_event.dart';
part 'update_driver_state.dart';

class UpdateDriverBloc extends Bloc<UpdateDriverEvent, UpdateDriverState> {
  final UpdateDriverAPIData datasource;
  UpdateDriverBloc(this.datasource) : super(UpdateDriverInitial()) {
    on<SubmitUpdateDriverEvent>((event, emit) async {
      emit(UpdateDriverLoading());
      try {
        final result = await datasource.updateDriver(event.request);
        emit(UpdateDriverSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(UpdateDriverFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(UpdateDriverFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
