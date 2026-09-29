import 'package:client_driver/data/dataSources/resend_otp_email_register_api_data.dart';
import 'package:client_driver/data/dataSources/verification_email_register_api_data.dart';
import 'package:client_driver/data/models/request/resend_otp_email_register_request_model.dart';
import 'package:client_driver/data/models/request/verification_email_register_request_model.dart';
import 'package:client_driver/data/models/response/resend_otp_email_register_response_model_model.dart';
import 'package:client_driver/data/models/response/verification_email_register_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'verification_email_register_event.dart';
part 'verification_email_register_state.dart';

class VerificationEmailRegisterBloc extends Bloc<VerificationEmailRegisterEvent,
    VerificationEmailRegisterState> {
  final VerificationEmailRegisterAPIData datasource;
  final ResendOTPEmailRegisterAPIData datasource2;
  VerificationEmailRegisterBloc(this.datasource, this.datasource2)
      : super(VerificationEmailRegisterInitial()) {
    // handle verification email

    on<SubmitVerificationEmailRegisterEvent>((event, emit) async {
      emit(VerificationEmailRegisterLoading());
      try {
        final result =
            await datasource.verificationEmailRegister(event.request);
        emit(VerificationEmailRegisterSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(VerificationEmailRegisterFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(VerificationEmailRegisterFailure(errorMessage: e.toString()));
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
