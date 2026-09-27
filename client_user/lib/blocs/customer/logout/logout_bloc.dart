import 'package:client_user/data/dataSources/logout_api_data.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutAPIData datasource;
  LogoutBloc(this.datasource) : super(LogoutInitial()) {
    on<PressedLogoutEvent>((event, emit) async {
      emit(LogoutLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        await datasource.logout();
        emit(LogoutLoaded());
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(LogoutFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(LogoutFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
