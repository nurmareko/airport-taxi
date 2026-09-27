import 'package:airport_taxi_sharing_driver_client/theme/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    super.initState();
  }

  @override
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                'images/welcome_3.jpg',
                width: double.infinity,
                height: 210.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Selamat Datang, Driver!',
              style: TextStyle(
                fontFamily: 'Arima',
                fontSize: 25.sp,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Aplikasi Airport Taxi Sharing!',
              style: TextStyle(
                fontFamily: 'Arima',
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'airporttaxisharingsupp@gmail.com',
                  style: TextStyle(
                    fontSize: 15.sp,
                  ),
                ),
              ],
            )
          ],
        ),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          color: Colors.white),
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
                      'Belum terdaftar ? Daftar dulu',
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
