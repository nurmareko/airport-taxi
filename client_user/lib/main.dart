import 'dart:convert';

import 'package:client_user/blocs/customer/updateTokenDevice/update_device_token_bloc.dart';
import 'package:client_user/blocs/order/addOrder/add_order_bloc.dart';
import 'package:client_user/blocs/order/cancelOrder/cancel_order_bloc.dart';
import 'package:client_user/blocs/order/getCurrentOrder/get_current_order_bloc.dart';
import 'package:client_user/blocs/order/getHistoryOrder/get_history_order_bloc.dart';
import 'package:client_user/blocs/order/getTaxisWithinRadius/get_taxis_within_radius_bloc.dart';
import 'package:client_user/blocs/customer/changePassword/change_password_bloc.dart';
import 'package:client_user/blocs/customer/checkAuthentication/check_authentication_bloc.dart';
import 'package:client_user/blocs/customer/forgotPassword/forgot_password_bloc.dart';
import 'package:client_user/blocs/customer/getCustomer/get_customer_bloc.dart';
import 'package:client_user/blocs/customer/login/login_bloc.dart';
import 'package:client_user/blocs/customer/logout/logout_bloc.dart';
import 'package:client_user/blocs/customer/register/register_bloc.dart';
import 'package:client_user/blocs/customer/resetPassword/reset_password_bloc.dart';
import 'package:client_user/blocs/customer/updateCustomer/update_customer_bloc.dart';
import 'package:client_user/blocs/customer/updateLocation/update_location_bloc.dart';
import 'package:client_user/blocs/customer/verificationEmailForgotPassword/verification_email_forgot_password_bloc.dart';
import 'package:client_user/blocs/customer/verificationEmailRegister/verification_email_register_bloc.dart';
import 'package:client_user/blocs/order/sendMessage/send_message_bloc.dart';
import 'package:client_user/blocs/order/sendReport/send_report_bloc.dart';
import 'package:client_user/blocs/order/sendReview/send_review_bloc.dart';
import 'package:client_user/data/dataSources/add_order_api_data.dart';
import 'package:client_user/data/dataSources/cancel_order_api_data.dart';
import 'package:client_user/data/dataSources/change_password_api_data.dart';
import 'package:client_user/data/dataSources/check_authentication_api_data.dart';
import 'package:client_user/data/dataSources/forgot_password_api_data.dart';
import 'package:client_user/data/dataSources/get_current_order_api_data.dart';
import 'package:client_user/data/dataSources/get_customer_api_data.dart';
import 'package:client_user/data/dataSources/get_history_order_api_data.dart';
import 'package:client_user/data/dataSources/get_taxis_within_radius.dart';
import 'package:client_user/data/dataSources/login_api_data.dart';
import 'package:client_user/data/dataSources/logout_api_data.dart';
import 'package:client_user/data/dataSources/register_api_data.dart';
import 'package:client_user/data/dataSources/resend_otp_email_forgot_password_api_data.dart';
import 'package:client_user/data/dataSources/resend_otp_email_register_api_data.dart';
import 'package:client_user/data/dataSources/reset_password_api_data.dart';
import 'package:client_user/data/dataSources/send_review_api_data.dart';
import 'package:client_user/data/dataSources/send_message_api_data.dart';
import 'package:client_user/data/dataSources/send_report_api_data.dart';
import 'package:client_user/data/dataSources/update_customer_api_data.dart';
import 'package:client_user/data/dataSources/update_device_token_api_data.dart';
import 'package:client_user/data/dataSources/update_location_api_data.dart';
import 'package:client_user/data/dataSources/verification_email_forgot_password_api_data.dart';
import 'package:client_user/data/dataSources/verification_email_register_api_data.dart';
import 'package:client_user/routes.dart';
import 'package:client_user/screens/splash_screen.dart';
import 'package:client_user/theme/colors.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi SecureStorage
  final SecureStorage secureStorage = SecureStorage();

  // Inisialisasi Flutter Local Notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.instance.getToken().then((value) async {
    print("getToken : $value");

    await secureStorage.updateDeviceToken(value!);

    // Mendapatkan dan mencetak device token yang disimpan
    String? storedDeviceToken = await secureStorage.getDeviceToken();
    print("Stored Device Token : $storedDeviceToken");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenApp: $message");
    Navigator.pushNamed(navigatorKey.currentState!.context, '/order',
        arguments: {"message": json.encode(message.data)});
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Navigator.pushNamed(navigatorKey.currentState!.context, '/order',
          arguments: {"message": json.encode(message.data)});
    }
  });

  // Add Firebase Messaging listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessage: $message");

    if (message.notification?.title != "update-latlng") {
      _showNotification(flutterLocalNotificationsPlugin, message);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("_firebaseMessagingBackgHandler : $message");
}

Future<void> _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(''),
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // notification id
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: json.encode(message.data),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth customer
        BlocProvider(
          create: (context) =>
              RegisterBloc(RegisterAPIData(), ResendOTPEmailRegisterAPIData()),
        ),
        BlocProvider(
          create: (context) => VerificationEmailRegisterBloc(
              VerificationEmailRegisterAPIData(),
              ResendOTPEmailRegisterAPIData()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(LoginAPIData(SecureStorage())),
        ),
        BlocProvider(
          create: (context) =>
              CheckAuthenticationBloc(CheckAuthenticationAPIData()),
        ),
        BlocProvider(
            create: (context) => ForgotPasswordBloc(ForgotPasswordAPIData())),
        BlocProvider(
            create: (context) => VerificationEmailForgotPasswordBloc(
                VerificationEmailForgotPasswordAPIData(),
                ResendOTPEmailForgotPasswordAPIData())),
        BlocProvider(
            create: (context) => ResetPasswordBloc(ResetPasswordAPIData())),

        BlocProvider(
            create: (context) => GetCustomerBloc(GetCustomerAPIData())),
        BlocProvider(
            create: (context) => UpdateCustomerBloc(UpdateCustomerAPIData())),
        BlocProvider(
            create: (context) => ChangePasswordBloc(ChangePasswordAPIData())),
        BlocProvider(create: (context) => LogoutBloc(LogoutAPIData())),
        BlocProvider(
            create: (context) => UpdateLocationBloc(UpdateLocationAPIData())),
        BlocProvider(
            create: (context) =>
                UpdateDeviceTokenBloc(UpdateDeviceTokenAPIData())),
        BlocProvider(
            create: (context) =>
                GetTaxisWithinRadiusBloc(GetTaxisWithinRadiusAPIData())),
        BlocProvider(
            create: (context) => GetCurrentOrderBloc(GetCurrentOrderAPIData())),
        BlocProvider(create: (context) => AddOrderBloc(AddOrderAPIData())),
        BlocProvider(
            create: (context) => CancelOrderBloc(CancelOrderAPIData())),
        BlocProvider(
            create: (context) => SendMessageBloc(SendMessageAPIData())),
        BlocProvider(create: (context) => SendReportBloc(SendReportAPIData())),
        BlocProvider(create: (context) => SendReviewBloc(SendReviewAPIData())),
        BlocProvider(
            create: (context) => GetHistoryOrderBloc(GetHistoryOrderAPIData()))
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        // splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aplikasi Airport Taxi Sharing Customer',
          theme: ThemeData.dark(
            useMaterial3: false,
          ).copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.grey),
            scaffoldBackgroundColor: AppColors.darkBackgroundBodyColor,
            textTheme: GoogleFonts.nunitoTextTheme().apply(
              bodyColor: Colors.white,
            ),
          ),
          home: const Splash(),
          navigatorKey: navigatorKey,
          routes: Routes.routes,
        ),
      ),
    );
  }
}
