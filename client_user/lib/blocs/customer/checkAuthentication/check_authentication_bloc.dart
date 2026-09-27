import 'package:client_user/data/dataSources/check_authentication_api_data.dart';
import 'package:client_user/data/models/response/check_authentication_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_authentication_event.dart';
part 'check_authentication_state.dart';

class CheckAuthenticationBloc extends Bloc<CheckAuthenticationEvent, CheckAuthenticationState> {
   final CheckAuthenticationAPIData datasource;
  CheckAuthenticationBloc(this.datasource) : super(CheckAuthenticationInitial()) {
    on<CheckAuthentication>((event, emit) async {
     emit(CheckAuthenticationLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.checkAuthentication();
        emit(CheckAuthenticationAuthenticated(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(CheckAuthenticationUnauthenticated(
              errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(CheckAuthenticationUnauthenticated(errorMessage: e.toString()));
        }
      }
    });
  }
}
