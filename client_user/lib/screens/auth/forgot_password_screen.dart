import 'package:client_user/blocs/customer/forgotPassword/forgot_password_bloc.dart';
import 'package:client_user/components/auth/app_bar.dart';
import 'package:client_user/components/error_message.dart';
import 'package:client_user/components/loading.dart';
import 'package:client_user/data/models/request/forgot_password_request_model.dart';
import 'package:client_user/theme/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? _errorMessage;

  // text controller
  TextEditingController emailController = TextEditingController();

  // set error text
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email harus diisi';
    } else if (!EmailValidator.validate(email)) {
      return 'Format email tidak valid';
    } else {
      return null;
    }
  }

  // Validasi apakah semua field sudah valid
  bool isFormValid() {
    return validateEmail(emailController.text) == null;
  }

  // widget loading
  Widget _buildLoadingModal(BuildContext context) {
    return const LoadingModal();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          Navigator.pushReplacementNamed(
              context, '/verificationEmailForgotPassword',
              arguments: {'email': state.model.email});
        } else if (state is ForgotPasswordFailure) {
          _errorMessage = state.errorMessage;
        }
      },
      builder: (context, state) {
        return Stack(children: [
          Scaffold(
            appBar: const AuthAppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Masukkan alamat email Anda untuk mengatur ulang kata sandi akun Anda.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      image: AssetImage('images/draft.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    ErrorWidgets.buildErrorMessageWidget(
                      'error',
                      _errorMessage.toString(),
                      Icons.error,
                      const Color.fromARGB(255, 155, 120, 118),
                      Colors.red,
                      Colors.red,
                      Colors.red,
                    ),
                  const SizedBox(height: 20),
                  const Text('Email',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          style: Theme.of(context).textTheme.titleMedium,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              hintText: "Masukkan email",
                              hintStyle: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                              errorText: validateEmail(emailController.text)),
                        ),
                      ),
                    ],
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
                                final requestModel = ForgotPasswordRequestModel(
                                  email: emailController.text,
                                );

                                context.read<ForgotPasswordBloc>().add(
                                      SubmitForgotPasswordEvent(
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
          if (state is ForgotPasswordLoading) _buildLoadingModal(context),
        ]);
      },
    );
  }
}
