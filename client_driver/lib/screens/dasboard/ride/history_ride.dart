import 'package:airport_taxi_sharing_driver_client/blocs/ride/getHistoryRide/get_history_ride_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading_data_background.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/errorScreen/error_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/ride/no_history_ride.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HistoryRide extends StatefulWidget {
  const HistoryRide({super.key});

  @override
  State<HistoryRide> createState() => _HistoryRideState();
}

class _HistoryRideState extends State<HistoryRide> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<GetHistoryRideBloc>().add(LoadGetHistoryRideEvent());
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  void _showRideDetailsModal(
      BuildContext context,
      rideId,
      double lat,
      double long,
      int pickupRadius,
      int rideStatus,
      String createDatetime,
      String updateDatetime) async {
    String statusText;
    switch (rideStatus) {
      case 1:
        statusText = 'Selesai Mengantar';
        break;
      case 2:
        statusText = 'Dibatalkan';
        break;
      case 3:
        statusText = 'Selesai';
      default:
        statusText = 'Status tidak diketahui';
    }

    // Mengonversi lat dan long menjadi nama lokasi
    String locationName = 'Loading...';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        locationName =
            '${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}, ${place.subAdministrativeArea}';
      } else {
        locationName = 'Tidak dapat menemukan lokasi';
      }
    } catch (e) {
      locationName = 'Error: $e';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: const Color(0xFF1E282C),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Detail Informasi Pengantaran Customer dari Bandara #$rideId',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.place,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Lokasi Penjemputan \n$locationName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Radius Pengantaran \n$pickupRadius meter',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.book,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Status \n$statusText',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.create,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Dibuat Pada \n$createDatetime',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.update,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Terahir Diperbarui \n$updateDatetime',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            BlocBuilder<GetHistoryRideBloc, GetHistoryRideState>(
              builder: (context, state) {
                if (state is GetHistoryRideLoading) {
                  return const LoadingModalDataBackground();
                } else if (state is GetHistoryRideLoaded) {
                  final rides = state.model.data;
                  if (rides.isEmpty) {
                    return const NoHistoryRide();
                  }
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Refresh untuk mendapatkan data terbaru',
                    type: AnimatedSnackBarType.info,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Riwayat pengantaran customer dari bandara',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: const Color(0xFF1E272E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rides.length,
                        itemBuilder: (context, index) {
                          final ride = rides[index];
                          return InkWell(
                            onTap: () {
                              _showRideDetailsModal(
                                  context,
                                  ride.id,
                                  ride.lat,
                                  ride.long,
                                  ride.pickupRadius,
                                  ride.rideStatus,
                                  ride.createDatetime,
                                  ride.updateDatetime);
                            },
                            child: Card(
                              color: const Color(0xFF1E282C),
                              margin: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                        color:
                                            Color.fromARGB(255, 33, 156, 144),
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  'images/map_3.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Pengantaran Customer \nBandara  #${ride.id}',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              const SizedBox(height: 15.0),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.info_outline,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    getStatusText(
                                                        ride.rideStatus),
                                                    style: TextStyle(
                                                        color: getStatusColor(
                                                            ride.rideStatus),
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 15.0),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        ride.createDatetime,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else if (state is GetHistoryRideFailure) {
                  if (state.errorMessage == "Unauthorized") {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Get.toNamed('/onBoarding');
                    });
                  }
                  return SomethingError(
                    onNavigate: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              const DasboardTemplate(initialPageIndex: 3),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Memuat Data...'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getStatusText(int status) {
  if (status == 1) {
    return 'Selesai Mengantar';
  } else if (status == 2) {
    return 'Batal';
  } else if (status == 3) {
    return 'Selesai';
  } else {
    return 'status tidak diketahui';
  }
}

Color getStatusColor(int status) {
  if (status == 1) {
    return Colors.blue;
  } else if (status == 2) {
    return Colors.red;
  } else if (status == 3) {
    return Colors.green;
  } else {
    return Colors.white;
  }
}
