import 'package:client_driver/data/dataSources/get_driver_api_data.dart';
import 'package:client_driver/data/models/response/get_driver_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_driver_event.dart';
part 'get_driver_state.dart';

class GetDriverBloc extends Bloc<GetDriverEvent, GetDriverState> {
  final GetDriverAPIData datasource;
  GetDriverBloc(this.datasource) : super(GetDriverInitial()) {
    on<LoadGetDriver>((event, emit) async {
      emit(GetDriverLoading());
      try {
        final result = await datasource.getDriverData();
        emit(GetDriverLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetDriverFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetDriverFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
