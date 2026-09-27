import 'package:client_user/screens/onBoarding/on_boarding_screen_1.dart';
import 'package:client_user/screens/onBoarding/on_boarding_screen_2.dart';
import 'package:client_user/screens/onBoarding/on_boarding_screen_3.dart';
import 'package:client_user/screens/onBoarding/on_boarding_screen_4.dart';
import 'package:client_user/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class OnBoardingTemplate extends StatefulWidget {
  const OnBoardingTemplate({super.key});

  @override
  State<OnBoardingTemplate> createState() => _OnBoardingTemplateState();
}

class _OnBoardingTemplateState extends State<OnBoardingTemplate> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'ATS',
              style: TextStyle(
                fontFamily: 'Arima',
                fontSize: 25,
              ),
            ),
            const SizedBox(width: 5),
            Image.asset('images/taxi_10.png', width: 45, height: 45),
          ],
        ),
        backgroundColor: AppColors.darkBackgroundBodyColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [
              OnBoarding1(),
              OnBoarding2(),
              OnBoarding3(),
              OnBoarding4(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.95),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              axisDirection: Axis.horizontal,
              effect: WormEffect(
                spacing: 8.0.w,
                radius: 4.0.w,
                dotWidth: 6.0.w,
                dotHeight: 6.0.h,
                paintStyle: PaintingStyle.stroke,
                strokeWidth: 1.5.w,
                dotColor: Colors.grey,
                activeDotColor: const Color.fromARGB(255, 33, 156, 144),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 200.h,
        color: AppColors.darkBackgroundBodyColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    backgroundColor: const Color.fromARGB(255, 33, 156, 144),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 33, 156, 144)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Text(
                      'Belum terdaftar? Daftar dulu',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 33, 156, 144),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Dengan masuk atau mendaftar, Anda menyetujui ',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.sp),
                          ),
                          TextSpan(
                            text: 'ketentuan layanan',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 33, 156, 144),
                                fontSize: 12.sp),
                          ),
                          TextSpan(
                            text: ' dan ',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.sp),
                          ),
                          TextSpan(
                            text: 'kebijakan privasi',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 33, 156, 144),
                                fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
