import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Sejajarkan konten secara horizontal
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
            'Selamat Datang!',
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
        ],
      ),
    );
  }
}
