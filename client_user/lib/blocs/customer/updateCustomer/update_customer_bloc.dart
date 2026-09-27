import 'package:client_user/data/dataSources/update_customer_api_data.dart';
import 'package:client_user/data/models/request/update_customer_request_model.dart';
import 'package:client_user/data/models/response/update_customer_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_customer_event.dart';
part 'update_customer_state.dart';

class UpdateCustomerBloc
    extends Bloc<UpdateCustomerEvent, UpdateCustomerState> {
  final UpdateCustomerAPIData datasource;
  UpdateCustomerBloc(this.datasource) : super(UpdateCustomerInitial()) {
    on<SubmitUpdateCustomerEvent>((event, emit) async {
      emit(UpdateCustomerLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.updateCustomer(event.request);
        emit(UpdateCustomerSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(UpdateCustomerFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(UpdateCustomerFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
