import 'package:client_driver/screens/auth/login_screen.dart';
import 'package:client_driver/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordSuccess extends StatelessWidget {
  const ResetPasswordSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String email = args['email'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBackgroundBodyColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'lottie/reset_password_success.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Reset Password Akun Berhasil!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Password akun dengan email ',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextSpan(
                        text: email,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 33, 156, 144)),
                      ),
                      const TextSpan(
                        text: ' sudah diperbarui!',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: const Color.fromARGB(255, 33, 156, 144),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Halaman Login',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
