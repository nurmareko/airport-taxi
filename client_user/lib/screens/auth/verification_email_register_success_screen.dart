import 'package:airport_taxi_sharing_user_client/screens/auth/login_screen.dart';
import 'package:airport_taxi_sharing_user_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VerificationEmailRegisterSuccess extends StatelessWidget {
  const VerificationEmailRegisterSuccess({super.key});

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
                'lottie/success_email_verification.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Verifikasi Email Berhasil!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Akun Anda dengan email ',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextSpan(
                        text: email,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 33, 156, 144)),
                      ),
                      const TextSpan(
                        text: ' sudah aktif!',
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
