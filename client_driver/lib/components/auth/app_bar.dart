import 'package:client_driver/theme/colors.dart';
import 'package:flutter/material.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? address;

  const AuthAppBar({super.key, this.address});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkBackgroundBodyColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          // if (address != null) {
          //   Navigator.of(context).pushNamed(address!);
          // } else {
          // Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/onBoarding');
          // }
        },
        iconSize: 30.0,
      ),
    );
  }
}
