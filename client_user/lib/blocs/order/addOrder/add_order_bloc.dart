import 'package:airport_taxi_sharing_user_client/data/dataSources/add_order_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/add_order_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/add_order_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_order_event.dart';
part 'add_order_state.dart';

class AddOrderBloc
    extends Bloc<AddOrderEvent, AddOrderState> {
  final AddOrderAPIData datasource;
  AddOrderBloc(
    this.datasource,
  ) : super(AddOrderInitial()) {
    on<SubmitAddOrderEvent>((event, emit) async {
      emit(AddOrderLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.addOrder(event.request);
        emit(AddOrderSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(AddOrderFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(AddOrderFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
