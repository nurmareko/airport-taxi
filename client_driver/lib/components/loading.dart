import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withValues(alpha: 0.4),
      child: Center(
        child: Lottie.asset(
          'lottie/loading3.json',
          width: 180,
          height: 180,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

