import 'package:client_user/blocs/customer/register/register_bloc.dart';
import 'package:client_user/components/auth/app_bar.dart';
import 'package:client_user/components/auth/unverified_error_register_bottom_sheet.dart';
import 'package:client_user/components/error_message.dart';
import 'package:client_user/components/loading.dart';

import 'package:client_user/data/models/request/register_request_model.dart';
import 'package:client_user/data/models/request/resend_otp_email_register_request_model.dart';

import 'package:client_user/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  // text field controller

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'Nama harus diisi';
    } else if (name.length < 3) {
      return 'Nama terlalu pendek';
    } else if (name.length > 15) {
      return 'Nama terlalu panjang';
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(String phoneNumber) {
    // Menghapus karakter selain digit dari nomor telepon
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (phoneNumber.isEmpty) {
      return 'Nomor HP harus diisi';
    } else if (!RegExp(r'^08[0-9]+$').hasMatch(phoneNumber) ||
        phoneNumber.length < 12 ||
        phoneNumber.length > 15) {
      return 'Format atau panjang nomor HP tidak valid';
    } else {
      return null;
    }
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password harus diisi';
    } else if (password.length < 8) {
      return 'Password minimal 8 karakter';
    } else if (!RegExp(r'(?=.*[a-z])(?=.*\d)').hasMatch(password) ||
        !RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password)) {
      return 'Gunakan kombinasi huruf, angka, dan karakter khusus';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password harus diisi';
    } else if (confirmPassword != password) {
      return 'Konfirmasi password tidak cocok';
    } else {
      return null;
    }
  }

  // Validasi apakah semua field sudah valid
  bool isFormValid() {
    return validateEmail(emailController.text) == null &&
        validateName(nameController.text) == null &&
        validatePhoneNumber(phoneNumberController.text) == null &&
        validatePassword(passwordController.text) == null &&
        validateConfirmPassword(
                passwordController.text, confirmPasswordController.text) ==
            null;
  }

  // widget loading
  Widget _buildLoadingModal(BuildContext context) {
    return const LoadingModal();
  }

  @override
  Widget build(BuildContext context) {
    bool isTextFieldEnabled = true;

    // void disableTextField() {
    //   isTextFieldEnabled = false;
    // }

    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushReplacementNamed(context, '/verificationEmail',
              arguments: {'email': state.model.email});
        } else if (state is RegisterFailure) {
          if (state.errorMessage == 'unverified') {
            _errorMessage = state.errorMessage;
            CustomBottomSheet.displayUnverifiedErrorBottomSheet(
                context, 'images/delete-message.png', () {
              final requestModel = ResendOTPEmailRegisterRequestModel(
                  email: state.email.toString());
              context.read<RegisterBloc>().add(
                    PressedResendOTPEmailRegisterEvent(request: requestModel),
                  );
            }, state.email.toString());
          } else {
            _errorMessage = state.errorMessage;
          }
        } else if (state is ResendOTPEmailRegisterFailure) {
          _errorMessage = state.errorMessage;
        } else if (state is ResendOTPEmailRegisterSuccess) {
          Navigator.pushReplacementNamed(context, '/verificationEmail',
              arguments: {'email': state.model.email});
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: const AuthAppBar(),
              body: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registrasi',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Silahkan masukkan email, nama, nomor HP, dan password Anda untuk mendaftar',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Image(
                          image: AssetImage('images/contacts_2.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_errorMessage == 'registered')
                        ErrorWidgets.buildErrorMessageWidget(
                          'registered',
                          'Akun dengan email ini sudah terdaftar',
                          Icons.error,
                          Colors.red,
                          Colors.red,
                          Colors.red,
                          Colors.red,
                        ),
                      if (_errorMessage != 'unverified' &&
                          _errorMessage != 'registered' &&
                          _errorMessage != null)
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
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
                              enabled: isTextFieldEnabled,
                              decoration: InputDecoration(
                                hintText: "Masukkan email",
                                hintStyle: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                                errorText: validateEmail(emailController.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Nama',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              style: Theme.of(context).textTheme.titleMedium,
                              keyboardType: TextInputType.name,
                              onChanged: (text) {
                                setState(() {});
                              },
                              enabled: isTextFieldEnabled,
                              decoration: InputDecoration(
                                  hintText: "Masukkan nama",
                                  hintStyle: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  errorText: validateName(nameController.text)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Nomor HP',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 244, 242, 242),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: 70,
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/indonesia.png',
                                  width: 20,
                                  height: 25,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  "+ 62",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: phoneNumberController,
                              style: Theme.of(context).textTheme.titleMedium,
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                setState(() {});
                              },
                              enabled: isTextFieldEnabled,
                              decoration: InputDecoration(
                                hintText: "Masukkan nomor HP (08...)",
                                hintStyle: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                                errorText: validatePhoneNumber(
                                    phoneNumberController.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Password',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Stack(
                        children: [
                          TextField(
                            controller: passwordController,
                            style: Theme.of(context).textTheme.titleMedium,
                            keyboardType: TextInputType.text,
                            obscureText: !_isPasswordVisible,
                            onChanged: (text) {
                              setState(() {});
                            },
                            enabled: isTextFieldEnabled,
                            decoration: InputDecoration(
                              hintText: "Masukkan password",
                              hintStyle: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                              contentPadding: const EdgeInsets.only(right: 40),
                              errorText:
                                  validatePassword(passwordController.text),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Konfirmasi Password',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Stack(
                        children: [
                          TextField(
                            controller: confirmPasswordController,
                            style: Theme.of(context).textTheme.titleMedium,
                            keyboardType: TextInputType.text,
                            obscureText: !_isConfirmPasswordVisible,
                            onChanged: (text) {
                              setState(() {});
                            },
                            enabled: isTextFieldEnabled,
                            decoration: InputDecoration(
                              hintText: "Masukkan konfirmasi password",
                              hintStyle: const TextStyle(
                                  fontSize: 15, color: Colors.grey),
                              contentPadding: const EdgeInsets.only(right: 40),
                              errorText: validateConfirmPassword(
                                  passwordController.text,
                                  confirmPasswordController.text),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                                  final requestModel = RegisterRequestModel(
                                    email: emailController.text,
                                    name: nameController.text,
                                    phoneNumber: phoneNumberController.text,
                                    password: passwordController.text,
                                  );

                                  context.read<RegisterBloc>().add(
                                        SubmitRegisterEvent(
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
                                  fontSize: 15.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is RegisterLoading) _buildLoadingModal(context),
            if (state is ResendOTPEmailRegisterLoading)
              _buildLoadingModal(context),
          ],
        );
      },
    );
  }
}
