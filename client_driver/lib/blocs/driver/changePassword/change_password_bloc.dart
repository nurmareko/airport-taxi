import 'package:client_driver/data/dataSources/change_password_api_data.dart';
import 'package:client_driver/data/models/request/change_password_request_model.dart';
import 'package:client_driver/data/models/response/change_password_response_model.dart';
import 'package:client_driver/error/new-exception.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordAPIData datasource;
  ChangePasswordBloc(this.datasource) : super(ChangePasswordInitial()) {
    on<SubmitChangePasswordEvent>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        final result = await datasource.changePassword(event.request);
        emit(ChangePasswordSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(ChangePasswordFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(ChangePasswordFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
