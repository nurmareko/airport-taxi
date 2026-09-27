import 'package:airport_taxi_sharing_user_client/data/dataSources/get_customer_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/get_customer_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_customer_event.dart';
part 'get_customer_state.dart';

class GetCustomerBloc extends Bloc<GetCustomerEvent, GetCustomerState> {
  final GetCustomerAPIData datasource;
  GetCustomerBloc(this.datasource) : super(GetCustomerInitial()) {
    on<LoadGetCustomer>((event, emit) async {
     emit(GetCustomerLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.getCustomerData();
        emit(GetCustomerLoaded(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(GetCustomerFailure(
              errorMessage: e.errorMessage));
        } else {
          print(e.toString());
          emit(GetCustomerFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
