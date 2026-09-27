import 'package:client_user/data/dataSources/get_current_order_api_data.dart';
import 'package:client_user/data/models/response/get_current_order_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_current_order_event.dart';
part 'get_current_order_state.dart';

class GetCurrentOrderBloc
    extends Bloc<GetCurrentOrderEvent, GetCurrentOrderState> {
  final GetCurrentOrderAPIData datasource;
  GetCurrentOrderBloc(this.datasource) : super(GetCurrentOrderInitial()) {
    on<LoadGetCurrentOrder>((event, emit) async {
      emit(GetCurrentOrderLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.getCurrentOrder();
        emit(GetCurrentOrderLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetCurrentOrderFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetCurrentOrderFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
