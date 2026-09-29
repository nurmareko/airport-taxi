import 'package:client_driver/data/dataSources/get_current_orderan_api_data.dart';
import 'package:client_driver/data/models/response/get_current_orderan_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_current_orderan_event.dart';
part 'get_current_orderan_state.dart';

class GetCurrentOrderanBloc
    extends Bloc<GetCurrentOrderanEvent, GetCurrentOrderanState> {
  final GetCurrentOrderanAPIData datasource;

  GetCurrentOrderanBloc(this.datasource)
      : super(
          RideInitial(),
        ) {
    // Get Current orderan
    on<LoadGetCurrentOrderanEvent>((event, emit) async {
      emit(GetCurrentOrderanLoading());
      try {
        final result = await datasource.getCurrentOrderanData();
        emit(GetCurrentOrderanLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetCurrentOrderanFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetCurrentOrderanFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
