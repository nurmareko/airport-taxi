// routes.dart

import 'package:airport_taxi_sharing_user_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/forgot_password_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/login_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/register_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/reset_password_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/reset_password_success_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/verification_email_forgot_password_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/verification_email_register_success_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/auth/verification_email_register_screen.dart';

import 'package:airport_taxi_sharing_user_client/screens/onBoarding/on_boarding_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static final Map<String, WidgetBuilder> routes = {
    '/splash': (context) => const Splash(),
    '/onBoarding': (context) => const OnBoardingTemplate(),
    '/register': (context) => const Register(),
    '/verificationEmail': (context) => const VerificationEmailRegister(),
    '/verificationEmailSuccess': (context) =>
        const VerificationEmailRegisterSuccess(),
    '/login': (context) => const Login(),
    '/forgotPassword': (context) => const ForgotPassword(),
    '/verificationEmailForgotPassword': (context) =>
        const VerificationEmailForgotPassword(),
    '/resetPassword': (context) => const ResetPassword(),
    '/resetPasswordSuccess': (context) => const ResetPasswordSuccess(),
    '/dasboardTemplate': (context) => const DasboardTemplate(),
    '/order': (context) => const DasboardTemplate(initialPageIndex: 2),
  };
}
