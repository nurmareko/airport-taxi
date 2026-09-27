import 'package:client_user/blocs/order/addOrder/add_order_bloc.dart';
import 'package:client_user/blocs/order/getTaxisWithinRadius/get_taxis_within_radius_bloc.dart';
import 'package:client_user/components/dasboard/confirmation_order_bottom_sheet.dart';
import 'package:client_user/components/dasboard/loading.dart';
import 'package:client_user/components/loading_data_background.dart';
import 'package:client_user/data/models/request/add_order_request_model.dart';
import 'package:client_user/data/models/response/get_taxis_within_radius_response_model.dart';
import 'package:client_user/screens/dasboard/dasboard_template_screen.dart';
import 'package:client_user/screens/dasboard/errorScreen/error_screen.dart';
import 'package:client_user/screens/dasboard/order/no_taxis_within_radius_screen.dart';
import 'package:client_user/utils/location_controller.dart';
import 'package:client_user/utils/location_service.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class GetTaxisWithinRadius extends StatefulWidget {
  const GetTaxisWithinRadius({super.key});

  @override
  State<GetTaxisWithinRadius> createState() => _GetTaxisWithinRadiusState();
}

class _GetTaxisWithinRadiusState extends State<GetTaxisWithinRadius> {
  double latitude = 0;
  double longitude = 0;

  final LocationController locationController =
      Get.put<LocationController>(LocationController());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    locationController.errorDescription.value = "";
    await LocationService.instance
        .getUserLocation(controller: locationController);
    setState(() {
      latitude = locationController.userLocation.value?.latitude ?? 0.0;
      longitude = locationController.userLocation.value?.longitude ?? 0.0;
    });

    context.read<GetTaxisWithinRadiusBloc>().add(LoadGetTaxisWithinRadius());
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Sedang proses';
      case 1:
        return 'Selesai mengantar';
      case 2:
        return 'Batal';
      case 3:
        return 'Selesdai';
      default:
        return 'Tidak Diketahui';
    }
  }

  void _showRideDetailsModal(
    BuildContext context,
    Ride ride,
    String rideId,
    DriverInfo driverInfo,
    Map<String, dynamic> distances,
    Map<String, dynamic> durations,
    int rideStatus,
    String estimatedCost,
    String createDateTime,
    String updateDateTime,
  ) {
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
                        'Detail Informasi Taksi Bandara Supadio #$rideId',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_taxi,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          driverInfo.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Tambahkan ikon bintang dan nilai rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.yellow, // Warna bintang
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              driverInfo.averageRating.toStringAsFixed(
                                  1), // Menampilkan rating dengan 1 desimal
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Text(
                    //   'Nomor Plat : ${driverInfo.licensePlate}',
                    //   style: const TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 14.0,
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _getStatusText(rideStatus),
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
                          Icons.access_time,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Estimasi Penjemputan \n${(durations['driverToCustomerDurationEstimate'] ?? '')}',
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
                          Icons.airplanemode_active,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Estimasi Ketibaan di Bandara \n${(durations['customerToAirportArrivalDurationEstimate'])}',
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
                          Icons.route,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Estimasi Jarak Lokasi Anda \nke Bandara \n${(distances["customerToAirportDistanceEstimate"])}',
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
                        const Text(
                          'Rp',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Estimasi Biaya \n$estimatedCost,00',
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
                          'Dibuat Pada \n$createDateTime',
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
                          'Diperbarui Pada \n$updateDateTime',
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
            BlocBuilder<GetTaxisWithinRadiusBloc, GetTaxisWithinRadiusState>(
              builder: (context, state) {
                if (state is GetTaxisWithinRadiusLoading) {
                  return const LoadingModalDataBackground();
                } else if (state is GetTaxisWithinRadiusLoaded) {
                  final rides = state.model.rides;
                  if (rides.isEmpty) {
                    return const NoTaxisWithinRadius();
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
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Taksi bandara yang tersedia',
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
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: rides.length,
                        itemBuilder: (context, index) {
                          final ride = rides[index];
                          return InkWell(
                            onTap: () {
                              _showRideDetailsModal(
                                context,
                                ride,
                                ride.id,
                                ride.driverInfo,
                                ride.distances,
                                ride.durations,
                                ride.rideStatus,
                                ride.estimatedCost,
                                ride.createDateTime,
                                ride.updateDateTime,
                              );
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
                                                  'images/taxi-icon.png'),
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
                                                'Taksi Bandara Supadio #${ride.id}',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              const SizedBox(height: 20.0),
                                              Row(
                                                children: [
                                                  // Elemen di kiri
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color: Colors.white,
                                                        size: 15.0,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        '${ride.durations['driverToCustomerDurationEstimate'] ?? ''}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  // Elemen di kanan
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .airplanemode_active,
                                                        color: Colors.white,
                                                        size: 15.0,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        '${ride.durations['customerToAirportArrivalDurationEstimate'] ?? ''}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 15.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            ConfirmationOrderBottomSheet
                                                .displayConfirmationBottomSheet(
                                              context,
                                              'Konfirmasi pemesanan Taksi Bandara Supadio #${ride.id}',
                                              'Apakah Anda yakin ingin memesan taksi ini untuk menuju ke Bandara? Pastikan lokasi penjemputan sudah sesuai!',
                                              'images/check.png',
                                              () {
                                                Navigator.pop(context);
                                                final addOrderRequestModel =
                                                    AddOrderRequestModel(
                                                        rideId: ride.id,
                                                        latitude: latitude,
                                                        longitude: longitude);

                                                context
                                                    .read<AddOrderBloc>()
                                                    .add(
                                                      SubmitAddOrderEvent(
                                                          request:
                                                              addOrderRequestModel),
                                                    );
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 33, 156, 144),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                          ),
                                          child: const Text(
                                            'Pesan',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        ride.createDateTime,
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
                } else if (state is GetTaxisWithinRadiusFailure) {
                  if (state.errorMessage == "Unauthorized") {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Get.toNamed('/onBoarding');
                    });
                  }
                  return SomethingError(onNavigate: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            const DasboardTemplate(initialPageIndex: 1),
                      ),
                    );
                  });
                } else {
                  return const Center(
                    child: Text('Memuat Data...'),
                  );
                }
              },
            ),
            BlocListener<AddOrderBloc, AddOrderState>(
              listener: (context, state) {
                if (state is AddOrderFailure) {
                  if (state.errorMessage == "Unauthorized") {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Get.toNamed('/onBoarding');
                    });
                  }
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Data pesanan gagal ditambahkan!',
                    type: AnimatedSnackBarType.error,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  _loadData();
                }
                if (state is AddOrderSuccess) {
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Data pesanan berhasil ditambahkan!',
                    type: AnimatedSnackBarType.success,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          const DasboardTemplate(initialPageIndex: 2),
                    ),
                  );
                }
              },
              child: BlocBuilder<AddOrderBloc, AddOrderState>(
                builder: (context, state) {
                  if (state is AddOrderLoading) {
                    return const LoadingModal();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
