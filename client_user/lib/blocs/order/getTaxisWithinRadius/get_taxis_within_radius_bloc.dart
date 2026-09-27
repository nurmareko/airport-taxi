import 'package:airport_taxi_sharing_user_client/data/dataSources/get_taxis_within_radius.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/get_taxis_within_radius_response_model.dart';

import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_taxis_within_radius_event.dart';
part 'get_taxis_within_radius_state.dart';

class GetTaxisWithinRadiusBloc extends Bloc<GetTaxisWithinRadiusEvent, GetTaxisWithinRadiusState> {
  final GetTaxisWithinRadiusAPIData datasource;
  GetTaxisWithinRadiusBloc(this.datasource) : super(GetTaxisWithinRadiusInitial()) {
    on<LoadGetTaxisWithinRadius>((event, emit) async {
      emit(GetTaxisWithinRadiusLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.getTaxisWithinRadius();
        emit(GetTaxisWithinRadiusLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetTaxisWithinRadiusFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetTaxisWithinRadiusFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
