import 'package:client_driver/data/dataSources/resend_otp_email_forgot_password_api_data.dart';
import 'package:client_driver/data/dataSources/verification_email_forgot_password_api_data.dart';
import 'package:client_driver/data/models/request/resend_otp_email_forgot_password_request_model.dart';
import 'package:client_driver/data/models/request/verification_email_forgot_password_request_model.dart';
import 'package:client_driver/data/models/response/resend_otp_email_forgot_password_response_model.dart';
import 'package:client_driver/data/models/response/verification_email_forgot_password_response_model.dart';
import 'package:client_driver/error/new-exception.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'verification_email_forgot_password_event.dart';
part 'verification_email_forgot_password_state.dart';

class VerificationEmailForgotPasswordBloc extends Bloc<
    VerificationEmailForgotPasswordEvent,
    VerificationEmailForgotPasswordState> {
  final VerificationEmailForgotPasswordAPIData datasource;
  final ResendOTPEmailForgotPasswordAPIData datasource2;
  VerificationEmailForgotPasswordBloc(this.datasource, this.datasource2)
      : super(VerificationEmailForgotPasswordInitial()) {
    // handle verification email

    on<SubmitVerificationEmailForgotPasswordEvent>((event, emit) async {
      emit(VerificationEmailForgotPasswordLoading());
      try {
        final result =
            await datasource.verificationEmailForgotPassword(event.request);
        emit(VerificationEmailForgotPasswordSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(VerificationEmailForgotPasswordFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(VerificationEmailForgotPasswordFailure(
              errorMessage: e.toString()));
        }
      }
    });

    // handle resend OTP code

    on<PressedResendOTPEmailForgotPasswordEvent>((event, emit) async {
      emit(ResendOTPEmailForgotPasswordLoading());
      try {
        await Future.delayed(const Duration(seconds: 5));
        final result =
            await datasource2.resendOTPEmailForgotPassword(event.request);
        emit(ResendOTPEmailForgotPasswordSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(ResendOTPEmailForgotPasswordFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(ResendOTPEmailForgotPasswordFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
