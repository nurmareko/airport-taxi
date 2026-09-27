import 'package:airport_taxi_sharing_user_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBottomBar extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const AuthBottomBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 100.h,
      color: AppColors.darkBackgroundBodyColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onMasukPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  backgroundColor: const Color.fromARGB(255, 33, 156, 144),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    'Selanjutnya',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMasukPressed() {
    // Aksi yang akan dijalankan saat tombol 'Masuk' ditekan
  }
}
