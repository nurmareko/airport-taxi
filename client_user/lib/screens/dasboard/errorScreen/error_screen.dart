import 'package:flutter/material.dart';

class SomethingError extends StatefulWidget {
  final Function onNavigate;

  const SomethingError({super.key, required this.onNavigate});

  @override
  _SomethingErrorState createState() => _SomethingErrorState();
}

class _SomethingErrorState extends State<SomethingError> {
  Future<void> _refresh() async {
    widget.onNavigate();
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
              'images/warning.png',
              width: 140,
              height: 140,
            ),
            const SizedBox(height: 20),
            const Text(
              'Terjadi kesalahan! Periksa koneksi internet Anda dan coba refresh halaman!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
