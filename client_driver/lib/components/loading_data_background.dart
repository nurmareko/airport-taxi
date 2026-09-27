import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingModalDataBackground extends StatelessWidget {
  const LoadingModalDataBackground({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      color: const Color(0xFF121B22),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.8),
          BlendMode.srcATop,
        ),
        child: Center(
          child: Lottie.asset(
            'lottie/loading_data_background.json',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
