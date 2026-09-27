import 'package:airport_taxi_sharing_driver_client/theme/colors.dart';
import 'package:flutter/material.dart';

class DasboardAppBarOne extends StatelessWidget implements PreferredSizeWidget {
  const DasboardAppBarOne({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'ATS',
            style: TextStyle(
              fontFamily: 'Arima',
              fontSize: 25,
            ),
          ),
          // const SizedBox(width: 5),
          // Image.asset('images/taxi_10.png', width: 45, height: 45),
        ],
      ),
      backgroundColor: AppColors.darkBackgroundBodyColor,
      elevation: 0,
    );
  }
}
