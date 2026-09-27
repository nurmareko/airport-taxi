import 'package:client_user/theme/colors.dart';
import 'package:flutter/material.dart';

class DasboardAppBarTwo extends StatelessWidget implements PreferredSizeWidget {
  final String selectedLabel;

  const DasboardAppBarTwo({super.key, required this.selectedLabel});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            selectedLabel, 
            style: const TextStyle(
              fontFamily: 'Arima',
              fontSize: 20,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.darkBackgroundBodyColor,
      elevation: 0.0,
    );
  }
}
