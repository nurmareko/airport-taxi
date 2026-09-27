import 'package:airport_taxi_sharing_user_client/data/dataSources/resend_otp_email_register_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/resend_otp_email_register_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/resend_otp_email_register_response_model_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:airport_taxi_sharing_user_client/data/dataSources/register_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/register_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/register_response_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterAPIData datasource;
  final ResendOTPEmailRegisterAPIData datasource2;

  RegisterBloc(this.datasource, this.datasource2) : super(RegisterInitial()) {
    on<SubmitRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        // await Future.delayed(const Duration(seconds: 5));
        final result = await datasource.register(event.request);
        emit(RegisterSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(RegisterFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(RegisterFailure(errorMessage: e.toString()));
        }
      }
    });

    // handle resend OTP code

    on<PressedResendOTPEmailRegisterEvent>((event, emit) async {
      emit(ResendOTPEmailRegisterLoading());
      try {
        await Future.delayed(const Duration(seconds: 5));
        final result = await datasource2.resendOTPEmailRegister(event.request);
        emit(ResendOTPEmailRegisterSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(ResendOTPEmailRegisterFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(ResendOTPEmailRegisterFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
