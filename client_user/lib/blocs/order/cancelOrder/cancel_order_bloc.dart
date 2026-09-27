import 'package:airport_taxi_sharing_user_client/data/dataSources/cancel_order_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/cancel_order_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/cancel_order_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cancel_order_event.dart';
part 'cancel_order_state.dart';

class CancelOrderBloc extends Bloc<CancelOrderEvent, CancelOrderState> {
  final CancelOrderAPIData datasource;
  CancelOrderBloc(this.datasource) : super(CancelOrderInitial()) {
    on<LoadCancelOrderEvent>((event, emit) async {
      emit(CancelOrderLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.cancelOrder(event.request);
        emit(CancelOrderSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(CancelOrderFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(CancelOrderFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
