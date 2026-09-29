import 'package:client_driver/blocs/driver/checkAuthentication/check_authentication_bloc.dart';
import 'package:client_driver/theme/colors.dart';
import 'package:client_driver/utils/location_controller.dart';
import 'package:client_driver/utils/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool showText = false;

  final LocationController locationController =
      Get.put<LocationController>(LocationController());

  @override
  void initState() {
    super.initState();
    checkLocationPermissionAndProceed();
  }

  Future<void> checkLocationPermissionAndProceed() async {
    await LocationService.instance
        .getUserLocation(controller: locationController);

    if (locationController.errorDescription.value.isNotEmpty) {
      // Jika ada error dengan layanan lokasi atau izin, tampilkan dialog dan keluar
      // Get.defaultDialog(
      //   title: "Permission Required",
      //   middleText: locationController.errorDescription.value,
      //   onConfirm: () {
      //     SystemNavigator.pop();
      //   },
      //   textConfirm: "Exit",
      // );
      SystemNavigator.pop();
    } else {
      delayedText();
    }
  }

  void delayedText() {
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showText = true;
      });
    }).then((_) {
      // Setelah animasi teks selesai, tunggu tambahan 5 detik sebelum menjalankan authenticationBloc
      Future.delayed(const Duration(seconds: 5), () {
        context.read<CheckAuthenticationBloc>().add(CheckAuthentication());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackgroundBodyColor,
      body: content(),
    );
  }

  Widget content() {
    return BlocConsumer<CheckAuthenticationBloc, CheckAuthenticationState>(
      listener: (context, state) {
        if (state is CheckAuthenticationLoading) {
        } else if (state is CheckAuthenticationAuthenticated) {
          Navigator.pushReplacementNamed(context, '/dasboardTemplate');
        } else if (state is CheckAuthenticationUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/onBoarding');
        }
      },
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.7, // 80% dari lebar layar
                height: MediaQuery.of(context).size.height *
                    0.3, // 40% dari tinggi layar
                child: Lottie.asset('lottie/splash.json'),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: showText,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 6.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: AnimatedTextKit(
                    repeatForever: false,
                    totalRepeatCount: 1,
                    onFinished: () {
                      // Teks selesai di animasikan, lakukan apa yang Anda inginkan di sini
                    },
                    animatedTexts: [
                      TyperAnimatedText('AIRPORT'),
                      TyperAnimatedText('TAXI'),
                      TyperAnimatedText('SHARING'),
                      TyperAnimatedText('DRIVER'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
