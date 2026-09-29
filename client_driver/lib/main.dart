import 'dart:convert';

import 'package:client_driver/blocs/driver/changePassword/change_password_bloc.dart';
import 'package:client_driver/blocs/driver/checkAuthentication/check_authentication_bloc.dart';
import 'package:client_driver/blocs/driver/forgotPassword/forgot_password_bloc.dart';
import 'package:client_driver/blocs/driver/getDriver/get_driver_bloc.dart';
import 'package:client_driver/blocs/driver/login/login_bloc.dart';
import 'package:client_driver/blocs/driver/logout/logout_bloc.dart';
import 'package:client_driver/blocs/driver/register/register_bloc.dart';
import 'package:client_driver/blocs/driver/resetPassword/reset_password_bloc.dart';
import 'package:client_driver/blocs/driver/updateDriver/update_driver_bloc.dart';
import 'package:client_driver/blocs/driver/updateLocation/update_location_bloc.dart';
import 'package:client_driver/blocs/driver/updateTokenDevice/update_device_token_bloc.dart';
import 'package:client_driver/blocs/driver/verificationEmailForgotPassword/verification_email_forgot_password_bloc.dart';
import 'package:client_driver/blocs/driver/verificationEmailRegister/verification_email_register_bloc.dart';
import 'package:client_driver/blocs/orderan/acceptOrderan/accept_orderan_bloc.dart';
import 'package:client_driver/blocs/orderan/cancelOrderan/cancel_orderan_bloc.dart';
import 'package:client_driver/blocs/orderan/getCurrentOrderan/get_current_orderan_bloc.dart';
import 'package:client_driver/blocs/orderan/getHistoryOrderan/get_history_orderan_bloc.dart';
import 'package:client_driver/blocs/orderan/rejectOrderan/reject_orderan_bloc.dart';
import 'package:client_driver/blocs/orderan/sendMessage/send_message_bloc.dart';
import 'package:client_driver/blocs/orderan/sendReport/send_report_bloc.dart';
import 'package:client_driver/blocs/orderan/sendReview/send_review_bloc.dart';
import 'package:client_driver/blocs/orderan/updateLocationOrderan/update_location_orderan_bloc.dart';
import 'package:client_driver/blocs/orderan/updateStatusOrderan/update_status_orderan_bloc.dart';
import 'package:client_driver/blocs/ride/addRide/add_ride_bloc.dart';
import 'package:client_driver/blocs/ride/cancelRide/cancel_ride_bloc.dart';
import 'package:client_driver/blocs/ride/completeAndCloseRide/complete_and_close_ride_bloc.dart';
import 'package:client_driver/blocs/ride/completeRide/complete_ride_bloc.dart';
import 'package:client_driver/blocs/ride/getCurrentRide/get_current_ride_bloc.dart';
import 'package:client_driver/blocs/ride/getHistoryRide/get_history_ride_bloc.dart';
import 'package:client_driver/data/dataSources/accept_orderan_api_data.dart';
import 'package:client_driver/data/dataSources/add_ride_api_data.dart';
import 'package:client_driver/data/dataSources/cancel_orderan_api_data.dart';
import 'package:client_driver/data/dataSources/cancel_ride_api_data.dart';
import 'package:client_driver/data/dataSources/change_password_api_data.dart';
import 'package:client_driver/data/dataSources/check_authentication_api_data.dart';
import 'package:client_driver/data/dataSources/complete_and_close_ride_api_data.dart';
import 'package:client_driver/data/dataSources/complete_ride_api_data.dart';
import 'package:client_driver/data/dataSources/forgot_password_api_data.dart';
import 'package:client_driver/data/dataSources/get_current_orderan_api_data.dart';
import 'package:client_driver/data/dataSources/get_current_ride_api_data.dart';
import 'package:client_driver/data/dataSources/get_driver_api_data.dart';
import 'package:client_driver/data/dataSources/get_history_orderan_api_data.dart';
import 'package:client_driver/data/dataSources/get_history_ride_api_data.dart';
import 'package:client_driver/data/dataSources/login_api_data.dart';
import 'package:client_driver/data/dataSources/logout_api_data.dart';
import 'package:client_driver/data/dataSources/register_api_data.dart';
import 'package:client_driver/data/dataSources/reject_orderan_api_data.dart';
import 'package:client_driver/data/dataSources/resend_otp_email_forgot_password_api_data.dart';
import 'package:client_driver/data/dataSources/resend_otp_email_register_api_data.dart';
import 'package:client_driver/data/dataSources/reset_password_api_data.dart';
import 'package:client_driver/data/dataSources/send_message_api_data.dart';
import 'package:client_driver/data/dataSources/send_report_api_data.dart';
import 'package:client_driver/data/dataSources/send_review_api_data.dart';
import 'package:client_driver/data/dataSources/update_device_token_api_data.dart';
import 'package:client_driver/data/dataSources/update_driver_api_data.dart';
import 'package:client_driver/data/dataSources/update_location_api_data.dart';
import 'package:client_driver/data/dataSources/update_location_orderan_api_data.dart';
import 'package:client_driver/data/dataSources/update_status_orderan_api_data.dart';
import 'package:client_driver/data/dataSources/verification_email_forgot_password_api_data.dart';
import 'package:client_driver/data/dataSources/verification_email_register_api_data.dart';
import 'package:client_driver/routes.dart';
import 'package:client_driver/screens/splash_screen.dart';
import 'package:client_driver/theme/colors.dart';
import 'package:client_driver/utils/location_tracking_service.dart';
import 'package:client_driver/utils/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocationService.instance.startLocationUpdates(
      UpdateLocationBloc(UpdateLocationAPIData()),
      UpdateLocationOrderanBloc(UpdateLocationOrderanAPIData()));

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
    Navigator.pushNamed(navigatorKey.currentState!.context, '/orderan',
        arguments: {"message": json.encode(message.data)});
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Navigator.pushNamed(navigatorKey.currentState!.context, '/orderan',
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
    systemNavigationBarColor: AppColors.darkBackgroundBodyColor,
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Driver
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

        BlocProvider(create: (context) => GetDriverBloc(GetDriverAPIData())),
        BlocProvider(
            create: (context) => UpdateDriverBloc(UpdateDriverAPIData())),
        BlocProvider(
            create: (context) => UpdateLocationBloc(UpdateLocationAPIData())),
        BlocProvider(
            create: (context) =>
                UpdateDeviceTokenBloc(UpdateDeviceTokenAPIData())),
        BlocProvider(
            create: (context) => ChangePasswordBloc(ChangePasswordAPIData())),
        BlocProvider(
            create: (context) => GetCurrentRideBloc(GetCurrentRideAPIData())),
        BlocProvider(create: (context) => AddRideBloc(AddRideAPIData())),
        BlocProvider(
            create: (context) => CompleteRideBloc(CompleteRideAPIData())),
        BlocProvider(
            create: (context) =>
                CompleteAndCloseRideBloc(CompleteAndCloseRideAPIData())),
        BlocProvider(create: (context) => CancelRideBloc(CancelRideAPIData())),
        BlocProvider(
            create: (context) => GetHistoryRideBloc(GetHistoryRideAPIData())),
        BlocProvider(
            create: (context) =>
                GetHistoryOrderanBloc(GetHistoryOrderanAPIData())),
        BlocProvider(
            create: (context) =>
                GetCurrentOrderanBloc(GetCurrentOrderanAPIData())),
        BlocProvider(
            create: (context) => AcceptOrderanBloc(AcceptOrderanAPIData())),
        BlocProvider(
            create: (context) => CancelOrderanBloc(CancelOrderanAPIData())),
        BlocProvider(
            create: (context) => RejectOrderanBloc(RejectOrderanAPIData())),
        BlocProvider(
            create: (context) =>
                UpdateStatusOrderanBloc(UpdateStatusOrderanAPIData())),
        BlocProvider(
            create: (context) =>
                UpdateLocationOrderanBloc(UpdateLocationOrderanAPIData())),
        BlocProvider(
            create: (context) => SendMessageBloc(SendMessageAPIData())),
        BlocProvider(create: (context) => SendReportBloc(SendReportAPIData())),
        BlocProvider(create: (context) => SendReviewBloc(SendReviewAPIData())),

        BlocProvider(create: (context) => LogoutBloc(LogoutAPIData())),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        // splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aplikasi Airport Taxi Sharing Driver',
          theme: ThemeData.dark(
            useMaterial3: false,
          ).copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.grey),
            scaffoldBackgroundColor: AppColors.darkBackgroundBodyColor,
            textTheme: GoogleFonts.nunitoTextTheme().apply(
              bodyColor: Colors.white,
            ),
            // textSelectionTheme: const TextSelectionThemeData(
            //   cursorColor: Colors.white,
            //   selectionColor: Colors.white,
            //   selectionHandleColor: Colors.white,
            // ),
            // inputDecorationTheme: const InputDecorationTheme(
            //   labelStyle: TextStyle(color: Colors.white),
            //   hintStyle: TextStyle(color: Colors.white),
            //   focusedBorder: UnderlineInputBorder(
            //     borderSide: BorderSide(color: Color(0xFF1F2C34)),
            //   ),
            // ),
          ),
          home: const Splash(),
          routes: Routes.routes,
        ),
      ),
    );
  }
}
