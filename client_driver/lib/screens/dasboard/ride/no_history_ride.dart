import 'package:client_driver/screens/dasboard/dasboard_template_screen.dart';
import 'package:flutter/material.dart';

class NoHistoryRide extends StatefulWidget {
  const NoHistoryRide({super.key});

  @override
  _NoHistoryRideState createState() => _NoHistoryRideState();
}

class _NoHistoryRideState extends State<NoHistoryRide> {
  Future<void> _refresh() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DasboardTemplate(initialPageIndex: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Image.asset(
              'images/no_data.png',
              width: 140,
              height: 140,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tidak ada data riwayat pengantaran yang tersedia',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
