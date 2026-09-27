import 'package:flutter/material.dart';

class LocationError extends StatefulWidget {
  final Function onNavigate;

  const LocationError({super.key, required this.onNavigate});

  @override
  _LocationErrorState createState() => _LocationErrorState();
}

class _LocationErrorState extends State<LocationError> {
  Future<void> _refresh() async {
    widget.onNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 100),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/error.png',
                    width: 140,
                    height: 140,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Terjadi kesalahan! \nSistem membutuhkan akses ke GPS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Coba untuk refresh halaman!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
