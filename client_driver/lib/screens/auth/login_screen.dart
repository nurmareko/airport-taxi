import 'package:airport_taxi_sharing_driver_client/blocs/driver/login/login_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/auth/app_bar.dart';
import 'package:airport_taxi_sharing_driver_client/components/error_message.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/login_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/theme/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  String? _errorMessage;

  // text controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password harus diisi';
    } else {
      return null;
    }
  }

  // Validasi apakah semua field sudah valid
  bool isFormValid() {
    return validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null;
  }

  // widget loading
  Widget _buildLoadingModal(BuildContext context) {
    return const LoadingModal();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, '/dasboardTemplate');
        } else if (state is LoginFailure) {
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
                    'Login',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Masukkan email dan password untuk masuk',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      image: AssetImage('images/login.png'),
                      width: 120,
                      height: 120,
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
                  const SizedBox(height: 20),
                  const Text('Password',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        decoration: InputDecoration(
                          hintText: "masukkan password",
                          hintStyle:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                          contentPadding: const EdgeInsets.only(right: 40),
                          errorText: validatePassword(passwordController.text),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/forgotPassword');
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 156, 144),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 100,
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
                                final requestModel = LoginRequestModel(
                                    email: emailController.text,
                                    password: passwordController.text);

                                context.read<LoginBloc>().add(
                                      SubmitLoginEvent(request: requestModel),
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 33, 156, 144),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 15,
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
          if (state is LoginLoading) _buildLoadingModal(context),
        ]);
      },
    );
  }
}
