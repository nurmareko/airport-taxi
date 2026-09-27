import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoarding2 extends StatelessWidget {
  const OnBoarding2({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Padding(
      padding: EdgeInsets.all(20.w), // Menggunakan ScreenUtil untuk padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Apa itu Aplikasi Airport Taxi Sharing?',
            style: TextStyle(
              fontFamily: 'Arima',
              fontSize: 20.sp, // Menggunakan ScreenUtil untuk fontSize
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10.h), // Menggunakan ScreenUtil untuk height
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              'images/taxi_12.jpg',
              width: double.infinity,
              height: 185.h, // Menggunakan ScreenUtil untuk height
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 15.h), // Menggunakan ScreenUtil untuk height
          Text(
            'Airport Taxi Sharing merupakan aplikasi yang ditujukan untuk meningkatkan efisiensi layanan taksi bandara.',
            style: TextStyle(
              fontFamily: 'Arima-Reguler',
              fontSize: 15.sp, // Menggunakan ScreenUtil untuk fontSize
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
