import 'package:airport_taxi_sharing_user_client/blocs/customer/verificationEmailForgotPassword/verification_email_forgot_password_bloc.dart';
import 'package:airport_taxi_sharing_user_client/components/auth/app_bar.dart';
import 'package:airport_taxi_sharing_user_client/components/error_message.dart';
import 'package:airport_taxi_sharing_user_client/components/loading.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/resend_otp_email_forgot_password_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/verification_email_forgot_password_request_model.dart';

import 'package:airport_taxi_sharing_user_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationEmailForgotPassword extends StatefulWidget {
  const VerificationEmailForgotPassword({super.key});

  @override
  State<VerificationEmailForgotPassword> createState() =>
      _VerificationEmailForgotPasswordState();
}

class _VerificationEmailForgotPasswordState
    extends State<VerificationEmailForgotPassword> {
  int timeLeft = 60;
  bool timerVisible = true;
  String? _errorMessage;

  // set form field and validation

  TextEditingController form1Controller = TextEditingController();
  TextEditingController form2Controller = TextEditingController();
  TextEditingController form3Controller = TextEditingController();
  TextEditingController form4Controller = TextEditingController();

  // clear form field

  void clearFieldNumber() {
    form1Controller.clear();
    form2Controller.clear();
    form3Controller.clear();
    form4Controller.clear();
  }

  bool isFormValid() {
    return form1Controller.text.isNotEmpty &&
        form2Controller.text.isNotEmpty &&
        form3Controller.text.isNotEmpty &&
        form4Controller.text.isNotEmpty;
  }

  String resultStringOTP() {
    return form1Controller.text +
        form2Controller.text +
        form3Controller.text +
        form4Controller.text;
  }

  // set timer

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (timeLeft == 0) {
          timer.cancel();
          timerVisible = false;
        } else {
          timeLeft--;
        }
      });
    });
  }

  // widget loading
  Widget _buildLoadingModal(BuildContext context) {
    return const LoadingModal();
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = timeLeft ~/ 60;
    int seconds = timeLeft % 60;
    String formattedTime = '$minutes:${seconds < 10 ? '0' : ''}$seconds';

    // email argument

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String email = args['email'];

    return BlocConsumer<VerificationEmailForgotPasswordBloc,
        VerificationEmailForgotPasswordState>(
      listener: (context, state) {
        if (state is VerificationEmailForgotPasswordSuccess) {
          Navigator.pushReplacementNamed(context, '/resetPassword',
              arguments: {'email': state.model.email});
        } else if (state is VerificationEmailForgotPasswordFailure) {
          _errorMessage = state.errorMessage;
        } else if (state is ResendOTPEmailForgotPasswordFailure) {
          _errorMessage = state.errorMessage;
        } else if (state is ResendOTPEmailForgotPasswordSuccess) {
          _errorMessage = null;
          clearFieldNumber();
          setState(() {
            timeLeft = 60;
            timerVisible = true;
            startCountdown();
          });
        }
      },
      builder: (context, state) {
        return Stack(children: [
          Scaffold(
            appBar: const AuthAppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verifikasi Email',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontFamily: 'Roboto-Reguler', fontSize: 16),
                      children: [
                        const TextSpan(
                          text: 'Kode OTP telah dikirimkan ke email ',
                        ),
                        TextSpan(
                          text: email,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 33, 156, 144),
                          ),
                        ),
                        const TextSpan(
                          text:
                              '. Silahkan masukkan 4 digit kode verifikasi untuk melakukan reset password.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    ErrorWidgets.buildErrorMessageWidget(
                      'error',
                      _errorMessage.toString(),
                      Icons.error,
                      Colors.red,
                      Colors.red,
                      Colors.red,
                      Colors.red,
                    ),

                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      image: AssetImage('images/password.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: TextFormField(
                            controller: form1Controller,
                            onChanged: (text) {
                              if (text.length == 1) {
                                FocusScope.of(context).nextFocus();
                                setState(() {});
                              }
                            },
                            onSaved: (pin1) {},
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: TextFormField(
                            controller: form2Controller,
                            onChanged: (text) {
                              if (text.length == 1) {
                                FocusScope.of(context).nextFocus();
                                setState(() {});
                              }
                            },
                            onSaved: (pin1) {},
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: TextFormField(
                            controller: form3Controller,
                            onChanged: (text) {
                              if (text.length == 1) {
                                FocusScope.of(context).nextFocus();
                                setState(() {});
                              }
                            },
                            onSaved: (pin1) {},
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: TextFormField(
                            controller: form4Controller,
                            onChanged: (text) {
                              if (text.length == 1) {
                                FocusScope.of(context).nextFocus();
                                setState(() {});
                              }
                            },
                            onSaved: (pin1) {},
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Tampilkan hitung mundur di sini di tengah
                  const SizedBox(height: 30),
                  Center(
                    child: Visibility(
                      visible: timerVisible,
                      child: Text(
                        formattedTime,
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'Roboto-Reguler'),
                      ),
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: !timerVisible,
                      child: TextButton(
                        onPressed: () {
                          final requestModel =
                              ResendOTPEmailForgotPasswordRequestModel(
                                  email: email);

                          context
                              .read<VerificationEmailForgotPasswordBloc>()
                              .add(
                                PressedResendOTPEmailForgotPasswordEvent(
                                    request: requestModel),
                              );
                        },
                        child: const Text(
                          'Kirim ulang kode?',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 33, 156, 144)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 100.h,
              color: AppColors.darkBackgroundBodyColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isFormValid()
                            ? () {
                                final requestModel =
                                    VerificationEmailForgotPasswordRequestModel(
                                        email: email, otp: resultStringOTP());

                                context
                                    .read<VerificationEmailForgotPasswordBloc>()
                                    .add(
                                      SubmitVerificationEmailForgotPasswordEvent(
                                          request: requestModel),
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 33, 156, 144),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (state is VerificationEmailForgotPasswordLoading)
            _buildLoadingModal(context),
          if (state is ResendOTPEmailForgotPasswordLoading)
            _buildLoadingModal(context),
        ]);
      },
    );
  }
}
