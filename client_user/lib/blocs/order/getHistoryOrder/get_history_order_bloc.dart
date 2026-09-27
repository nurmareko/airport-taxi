import 'package:client_user/data/dataSources/get_history_order_api_data.dart';
import 'package:client_user/data/models/response/get_history_order_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_history_order_event.dart';
part 'get_history_order_state.dart';

class GetHistoryOrderBloc
    extends Bloc<GetHistoryOrderEvent, GetHistoryOrderState> {
  final GetHistoryOrderAPIData datasource;
  GetHistoryOrderBloc(this.datasource) : super(GetHistoryOrderInitial()) {
    on<LoadGetHistoryOrder>((event, emit) async {
      emit(GetHistoryOrderLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.getHistoryOrder();
        emit(GetHistoryOrderLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetHistoryOrderFailure(errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetHistoryOrderFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
