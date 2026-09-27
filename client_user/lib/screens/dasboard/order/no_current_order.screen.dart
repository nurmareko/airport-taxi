import 'package:airport_taxi_sharing_user_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:flutter/material.dart';

class NoCurrentOrder extends StatefulWidget {
  const NoCurrentOrder({super.key});

  @override
  _NoCurrentOrderState createState() => _NoCurrentOrderState();
}

class _NoCurrentOrderState extends State<NoCurrentOrder> {
  Future<void> _refresh() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DasboardTemplate(initialPageIndex: 2),
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
              'images/no-data.png',
              width: 140,
              height: 140,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tidak ada data pesanan yang sedang berlangsung',
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
