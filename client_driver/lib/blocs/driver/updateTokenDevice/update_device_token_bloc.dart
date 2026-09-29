import 'package:client_driver/data/dataSources/update_device_token_api_data.dart';
import 'package:client_driver/data/models/request/update_device_token_request_model.dart';
import 'package:client_driver/data/models/response/update_device_token_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_device_token_event.dart';
part 'update_device_token_state.dart';

class UpdateDeviceTokenBloc
    extends Bloc<UpdateDeviceTokenEvent, UpdateDeviceTokenState> {
  final UpdateDeviceTokenAPIData datasource;
  UpdateDeviceTokenBloc(this.datasource) : super(UpdateDeviceTokenInitial()) {
    on<LoadUpdateDeviceTokenEvent>((event, emit) async {
      emit(UpdateDeviceTokenLoading());
      try {
        final result = await datasource.updateDeviceToken(event.request);
        emit(UpdateDeviceTokenSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(UpdateDeviceTokenFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(UpdateDeviceTokenFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
