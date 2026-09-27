import 'package:client_user/blocs/customer/resetPassword/reset_password_bloc.dart';
import 'package:client_user/data/models/request/reset_password_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_user/components/auth/app_bar.dart';
import 'package:client_user/components/error_message.dart';
import 'package:client_user/components/loading.dart';
import 'package:client_user/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPassword> {
  final bool _isPasswordVisible = false;
  String? _errorMessage;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? validateNewPassword(String password) {
    if (password.isEmpty) {
      return 'Password harus diisi';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Password harus diisi';
    } else if (confirmPassword != newPasswordController.text) {
      return 'Konfirmasi password tidak sesuai';
    } else {
      return null;
    }
  }

  bool isFormValid() {
    return validateNewPassword(newPasswordController.text) == null &&
        validateConfirmPassword(confirmPasswordController.text) == null;
  }

  Widget _buildLoadingModal(BuildContext context) {
    return const LoadingModal();
  }

  @override
  Widget build(BuildContext context) {
    // email argument

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String email = args['email'];

    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          Navigator.pushReplacementNamed(context, '/resetPasswordSuccess',
              arguments: {'email': state.model.email});
        } else if (state is ResetPasswordFailure) {
          _errorMessage = state.errorMessage;
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: const AuthAppBar(),
              body: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reset Password',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Masukkan password baru dan konfirmasi password untuk melakukan reset password',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Image(
                        image: AssetImage('images/reset-password.png'),
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
                    const Text('Password baru',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: newPasswordController,
                      style: Theme.of(context).textTheme.titleMedium,
                      keyboardType: TextInputType.text,
                      obscureText: !_isPasswordVisible,
                      onChanged: (text) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Masukkan password baru",
                        hintStyle:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                        errorText:
                            validateNewPassword(newPasswordController.text),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Konfirmasi Password',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: confirmPasswordController,
                      style: Theme.of(context).textTheme.titleMedium,
                      keyboardType: TextInputType.text,
                      obscureText: !_isPasswordVisible,
                      onChanged: (text) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Masukkan konfirmasi password",
                        hintStyle:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                        errorText: validateConfirmPassword(
                            confirmPasswordController.text),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                      ResetPasswordRequestModel(
                                          email: email,
                                          password: newPasswordController.text);

                                  context.read<ResetPasswordBloc>().add(
                                        SubmitResetPasswordEvent(
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
            if (state is ResetPasswordLoading) _buildLoadingModal(context),
          ],
        );
      },
    );
  }
}
