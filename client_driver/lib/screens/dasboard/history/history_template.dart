import 'package:client_driver/screens/dasboard/orderan/history_orderan.dart';
import 'package:client_driver/screens/dasboard/ride/history_ride.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with TickerProviderStateMixin {
  late TabController _firstTabController;
  late TabController _secondTabController;

  @override
  void initState() {
    super.initState();
    _firstTabController = TabController(length: 2, vsync: this);
    _secondTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _firstTabController.dispose();
    _secondTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _firstTabController,
          tabs: const [
            Tab(text: 'Riwayat Pengantaran'),
            Tab(text: 'Riwayat Pesanan'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _firstTabController,
            children: const [
              HistoryRide(),
              HistoryOrderan(),
            ],
          ),
        ),
      ],
    );
  }
}
