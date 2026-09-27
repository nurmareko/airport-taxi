import 'package:client_user/data/dataSources/login_api_data.dart';
import 'package:client_user/data/models/request/login_request_model.dart';
import 'package:client_user/data/models/response/login_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginAPIData datasource;
  LoginBloc(
    this.datasource,
  ) : super(LoginInitial()) {
    on<SubmitLoginEvent>((event, emit) async {
      emit(LoginLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.login(event.request);
        emit(LoginSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(LoginFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(LoginFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
