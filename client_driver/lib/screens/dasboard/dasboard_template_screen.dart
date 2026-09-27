import 'package:airport_taxi_sharing_driver_client/components/dasboard/app_bar_1.dart';
import 'package:airport_taxi_sharing_driver_client/components/dasboard/app_bar_2.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/account/account_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/beranda_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/history/history_template.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/orderan/orderan_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/ride/ride_screen.dart';
import 'package:airport_taxi_sharing_driver_client/theme/colors.dart';
import 'package:flutter/material.dart';

class DasboardTemplate extends StatefulWidget {
  final int initialPageIndex; // Parameter untuk menentukan halaman awal

  const DasboardTemplate({super.key, this.initialPageIndex = 0});

  @override
  State<DasboardTemplate> createState() => _DasboardTemplateState();
}

class _DasboardTemplateState extends State<DasboardTemplate> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPageIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 1:
        return 'Pengantaran';
      case 2:
        return 'Pesanan';
      case 3:
        return 'Riwayat';
      case 4:
        return 'Akun';
      default:
        return '';
    }
  }

  final List<Widget> _widgetOptions = <Widget>[
    const Beranda(),
    const Ride(),
    const Orderan(),
    const History(),
    const Account(),
  ];

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar;
    if (_selectedIndex == 0) {
      appBar = const DasboardAppBarOne();
    } else {
      // Pass the label to DashboardAppBarTwo
      String label = _getLabelForIndex(_selectedIndex);
      appBar = DasboardAppBarTwo(selectedLabel: label);
    }

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        // height: 70.h,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Beranda',
              backgroundColor: AppColors.darkBackgroundBodyColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Pengantaran',
              backgroundColor: AppColors.darkBackgroundBodyColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_taxi_outlined),
              label: 'Pesanan',
              backgroundColor: AppColors.darkBackgroundBodyColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_outlined),
              label: 'Riwayat',
              backgroundColor: AppColors.darkBackgroundBodyColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Akun',
              backgroundColor: AppColors.darkBackgroundBodyColor,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          iconSize: 28,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class OrderanPage extends StatelessWidget {
  const OrderanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Orderan Page',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class HistoryListPage extends StatelessWidget {
  const HistoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'History Page',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

