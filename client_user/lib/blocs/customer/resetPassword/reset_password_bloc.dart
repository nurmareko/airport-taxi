import 'package:airport_taxi_sharing_user_client/data/dataSources/reset_password_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/reset_password_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/reset_password_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordAPIData datasource;
  ResetPasswordBloc(
     this.datasource
  ) : super(ResetPasswordInitial()) {
    on<SubmitResetPasswordEvent>((event, emit) async {
     emit(ResetPasswordLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result =
            await datasource.resetPassword(event.request);
        emit(ResetPasswordSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(ResetPasswordFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(ResetPasswordFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
