import 'package:airport_taxi_sharing_driver_client/data/dataSources/get_history_orderan_api_data.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/get_history_orderan_reponse_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_history_orderan_event.dart';
part 'get_history_orderan_state.dart';

class GetHistoryOrderanBloc
    extends Bloc<GetHistoryOrderanEvent, GetHistoryOrderanState> {
  final GetHistoryOrderanAPIData datasource;

  GetHistoryOrderanBloc(this.datasource)
      : super(
          RideInitial(),
        ) {
    // Get history orderan
    on<LoadGetHistoryOrderanEvent>((event, emit) async {
      emit(GetHistoryOrderanLoading());
      try {
        final result = await datasource.getHistoryOrderanData();
        emit(GetHistoryOrderanLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetHistoryOrderanFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetHistoryOrderanFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
