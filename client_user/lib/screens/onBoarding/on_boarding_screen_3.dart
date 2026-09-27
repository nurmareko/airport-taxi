import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoarding3 extends StatelessWidget {
  const OnBoarding3({super.key});

  // Fungsi untuk menampilkan alert dengan gambar dan pesan yang berbeda
  void showImageAlert(
      BuildContext context, String message, String imagePath, String index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0.w),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Nomor index di atas
              Container(
                padding: EdgeInsets.all(12.0.w),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 33, 156, 144),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  index,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto-Reguler',
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0.w),
                child: Image.asset(
                  imagePath,
                  width: 120.0.w,
                  height: 120.0.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.0.h),
              Text(
                message,
                style: TextStyle(
                  fontFamily: 'Arima-Reguler',
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OKE',
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 156, 144),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget untuk menampilkan gambar dengan GestureDetector
  Widget buildImageWithGesture(
      BuildContext context, String message, String imagePath, String index) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showImageAlert(context, message, imagePath, index);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 2.w,
                  blurRadius: 5.w,
                  offset: Offset(0.w, 3.h),
                ),
              ],
            ),
            padding: EdgeInsets.all(8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0.w),
              child: Image.asset(
                imagePath,
                width: 110.0.w,
                height: 110.0.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.h,
          left: 0.w,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 2.w,
                  blurRadius: 5.w,
                  offset: Offset(0.w, 3.h),
                ),
              ],
            ),
            padding: EdgeInsets.all(8.w),
            child: Text(
              index,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Bagaimana Aplikasi Ini Bekerja?',
            style: TextStyle(
              fontFamily: 'Arima',
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildImageWithGesture(
                context,
                'Driver membagikan titik pengantaran dari penumpang bandara dengan radius tertentu.',
                'images/customer-journey.png',
                '1',
              ),
              SizedBox(width: 40.w),
              buildImageWithGesture(
                context,
                'Kamu dapat mencari ketersediaan taksi bandara yang tersedia di sekitarmu dalam radius tertentu (berdasarkan titik pengantaran yang dibagikan oleh driver), memesan taksi tersebut, dan melihat informasi yang dibutuhkan untuk melakukan pemesanan.',
                'images/online-booking.png',
                '2',
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildImageWithGesture(
                context,
                'Nah, kamu dapat melakukan pemesanan taksi menuju bandara melalui aplikasi ini. Setelah pesanan yang kamu buat diterima oleh driver, kamu juga bisa memantau pembaruan posisi driver, membatalkan pesanan jika diperlukan, serta melihat estimasi waktu kedatangan, estimasi biaya, dan informasi pemesanan lainnya.',
                'images/taxi_13.png',
                '3',
              ),
              SizedBox(width: 40.w),
              buildImageWithGesture(
                context,
                'Taksi bandara akan mengantar kamu menuju bandara, dan proses pemesanan pun selesai. Setelah pemesanan selesai, kamu dapat melakukan pembayaran secara tunai sesuai estimasi biaya yang disediakan aplikasi, serta memberikan rating dan ulasan untuk driver.',
                'images/taxi_14.png',
                '4',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
