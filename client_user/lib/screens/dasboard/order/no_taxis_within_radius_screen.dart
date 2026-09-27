import 'package:client_user/screens/dasboard/dasboard_template_screen.dart';
import 'package:flutter/material.dart';

class NoTaxisWithinRadius extends StatefulWidget {
  const NoTaxisWithinRadius({super.key});

  @override
  _NoTaxisWithinRadiusState createState() => _NoTaxisWithinRadiusState();
}

class _NoTaxisWithinRadiusState extends State<NoTaxisWithinRadius> {
  Future<void> _refresh() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DasboardTemplate(initialPageIndex: 1),
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
              'images/no-taxi.png',
              width: 140,
              height: 140,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tidak ada data pengantaran taksi bandara yang akan menuju lokasi sekitar Anda',
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
