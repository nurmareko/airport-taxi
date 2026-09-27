import 'package:client_user/components/dasboard/app_bar_1.dart';
import 'package:client_user/components/dasboard/app_bar_2.dart';
import 'package:client_user/screens/dasboard/account/account_screen.dart';
import 'package:client_user/screens/dasboard/beranda/beranda_screen.dart';
import 'package:client_user/screens/dasboard/order/get_history_order_screen.dart';
import 'package:client_user/screens/dasboard/order/get_taxis_within_radius_screen.dart';
import 'package:client_user/screens/dasboard/order/order_screen.dart';
import 'package:client_user/theme/colors.dart';
import 'package:flutter/material.dart';

class DasboardTemplate extends StatefulWidget {
  final int initialPageIndex;
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
        return 'Pesan Taksi';
      case 2:
        return 'Pesanan Taksi';
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
    const GetTaxisWithinRadius(),
    const Order(),
    const HistoryOrder(),
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
              icon: Icon(Icons.local_taxi),
              label: 'Pesan Taksi',
              backgroundColor: AppColors.darkBackgroundBodyColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.taxi_alert_rounded),
              label: 'Pesanan',
              backgroundColor: Color.fromRGBO(18, 27, 34, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_outlined),
              label: 'Riwayat Pesanan',
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

class OrderTaxiListPage extends StatelessWidget {
  const OrderTaxiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Order Page',
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
        'History Order Page',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
