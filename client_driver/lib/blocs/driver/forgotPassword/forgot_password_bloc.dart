import 'package:airport_taxi_sharing_driver_client/data/dataSources/forgot_password_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/forgot_password_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/forgot_password_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordAPIData datasource;
  ForgotPasswordBloc(
    this.datasource,
  ) : super(ForgotPasswordInitial()) {
    on<SubmitForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        final result = await datasource.forgotPassword(event.request);
        emit(ForgotPasswordSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(ForgotPasswordFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(ForgotPasswordFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
