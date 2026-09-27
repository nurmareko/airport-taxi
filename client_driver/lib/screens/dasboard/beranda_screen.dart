// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:airport_taxi_sharing_driver_client/blocs/driver/updateTokenDevice/update_device_token_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/getCurrentOrderan/get_current_orderan_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/ride/getCurrentRide/get_current_ride_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_device_token_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/errorScreen/error_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/errorScreen/location_error_screen.dart';
import 'package:airport_taxi_sharing_driver_client/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/driver/getDriver/get_driver_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/driver/updateLocation/update_location_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading_data_background.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_location_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_driver_client/utils/location_controller.dart';
import 'package:airport_taxi_sharing_driver_client/utils/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  double latitude = 0;
  double longitude = 0;

  // Inisialisasi SecureStorage
  final SecureStorage secureStorage = SecureStorage();

  final LocationController locationController =
      Get.put<LocationController>(LocationController());

  BitmapDescriptor markerIconCustomer = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconTaxi = BitmapDescriptor.defaultMarker;

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

    final requestModelLocation = UpdateLocationRequestModel(
      latitude: latitude,
      longitude: longitude,
    );

    final storedDeviceToken = await secureStorage.getDeviceToken();

    final requestModelDeviceToken =
        UpdateDeviceTokenRequestModel(deviceToken: storedDeviceToken!);

    context.read<UpdateDeviceTokenBloc>().add(
          LoadUpdateDeviceTokenEvent(request: requestModelDeviceToken),
        );

    context.read<UpdateLocationBloc>().add(
          LoadUpdateLocationEvent(request: requestModelLocation),
        );

    context.read<GetDriverBloc>().add(LoadGetDriver());
    context.read<GetCurrentRideBloc>().add(LoadGetCurrentRideEvent());
    context.read<GetCurrentOrderanBloc>().add(LoadGetCurrentOrderanEvent());
  }

  Future<String> _convertLatLngToAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      } else {
        return "No address available";
      }
    } catch (e) {
      return "Failed to get location";
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Obx(
          () {
            if (locationController.isAccessingLocation.value) {
              return const LoadingModalDataBackground();
            } else if (locationController.errorDescription.value.isNotEmpty ||
                locationController.userLocation.value == null) {
              return LocationError(onNavigate: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DasboardTemplate(initialPageIndex: 0),
                  ),
                );
              });
            } else {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          BlocBuilder<GetDriverBloc, GetDriverState>(
                            builder: (context, state) {
                              return _buildProfileContent(context, state);
                            },
                          ),
                          // Row(
                          //   children: [
                          //     const Padding(
                          //       padding: EdgeInsets.only(left: 10.0),
                          //       child: Text(
                          //         'Aktifitas Pengantaran Aktif',
                          //         style: TextStyle(
                          //           fontSize: 14.0,
                          //           fontWeight: FontWeight.normal,
                          //           color: Colors.white70,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10),
                          //     Expanded(
                          //       child: Container(
                          //         height: 2,
                          //         color: const Color(0xFF1E272E),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 10),
                          BlocBuilder<GetCurrentRideBloc, GetCurrentRideState>(
                            builder: (context, state) {
                              return _buildCurrentRideContent(context, state);
                            },
                          ),
                          const SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     const Padding(
                          //       padding: EdgeInsets.only(left: 10.0),
                          //       child: Text(
                          //         'Aktifitas Pesanan Aktif',
                          //         style: TextStyle(
                          //           fontSize: 14.0,
                          //           fontWeight: FontWeight.normal,
                          //           color: Colors.white70,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10),
                          //     Expanded(
                          //       child: Container(
                          //         height: 2,
                          //         color: const Color(0xFF1E272E),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 10),
                          BlocBuilder<GetCurrentOrderanBloc,
                              GetCurrentOrderanState>(
                            builder: (context, state) {
                              return _buildCurrentOrderanContent(
                                  context, state);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, GetDriverState state) {
    if (state is GetDriverLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetDriverLoaded) {
      return _buildLoadedProfileContent(state);
    } else if (state is GetDriverFailure) {
      if (state.errorMessage == "Unauthorized") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/onBoarding');
        });
      }
      return SomethingError(onNavigate: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DasboardTemplate(initialPageIndex: 0),
          ),
        );
      });
    } else {
      return const Center(
        child: Text('Memuat Data...'),
      );
    }
  }

  Widget _buildLoadedProfileContent(GetDriverLoaded state) {
    final String name = state.model.name;
    final String email = state.model.email;
    final String phoneNumber = state.model.phoneNumber;
    final String photo = state.model.photo;
    final double latitude = state.model.lat;
    final double longitude = state.model.long;

    return Column(children: [
      SizedBox(
        height: 270,
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 210,
                width: 350,
                decoration: BoxDecoration(
                  color: const Color(0xFF121B22),
                  border: Border.all(
                    color: const Color(0xFF1E272E),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 40,
              child: SizedBox(
                width: 60,
                height: 60,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: photo,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 55,
              left: 20,
              child: Text(
                'Hello $name,',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Positioned(
              top: 85,
              left: 20,
              child: Text(
                'Aktif',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              top: 115,
              left: 20,
              child: FutureBuilder<List<Placemark>>(
                future: placemarkFromCoordinates(latitude, longitude),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return const Text('Terjadi kesalahan...');
                    } else {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final Placemark placemark = snapshot.data![0];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${placemark.name}, ${placemark.street} ${placemark.subLocality},',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${placemark.locality}, ${placemark.administrativeArea},',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${placemark.country}, ${placemark.postalCode}, ${placemark.subAdministrativeArea}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text('Terjadi kesalahan...');
                      }
                    }
                  }
                },
              ),
            ),
            Positioned(
              top: 175,
              left: 15,
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "(+62) $phoneNumber",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 65,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        const DasboardTemplate(initialPageIndex: 4),
                  ));
                },
                child: const Center(
                  child: Text(
                    "Lihat Profil",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildCurrentRideContent(
      BuildContext context, GetCurrentRideState state) {
    if (state is GetCurrentRideLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetCurrentRideLoaded) {
      return _buildLoadedCurrentRideContent(state);
    } else if (state is GetCurrentRideFailure) {
      if (state.errorMessage == "Unauthorized") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/onBoarding');
        });
      }
      if (state.errorMessage == "no_current_ride") {
        return Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Aktifitas Pengantaran Aktif',
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'images/no_data.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tidak ada pengantaran aktif",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ]);
      }

      return const Center(
        child: Text(''),
      );
    } else {
      return const Center(
        child: Text('...'),
      );
    }
  }

  Widget _buildLoadedCurrentRideContent(GetCurrentRideLoaded state) {
    final rideId = state.model.id;
    final rideLat = state.model.lat;
    final rideLong = state.model.long;

    return FutureBuilder<String>(
      future: _convertLatLngToAddress(rideLat, rideLong),
      builder: (context, snapshot) {
        String locationName = "Loading...";
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            locationName = snapshot.data!;
          } else if (snapshot.hasError) {
            locationName = "Failed to get location";
          }
        }

        return Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Aktifitas Pengantaran Aktif',
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
          SizedBox(
            width: double.infinity,
            child: Card(
              color: const Color(0xFF1E282C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Tambahkan Gambar di sisi kiri
                        Image.asset(
                          'images/route.png', // Ganti dengan path gambar yang sesuai
                          width: 45, // Sesuaikan ukuran gambar sesuai kebutuhan
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                            width: 10), // Jarak antara gambar dan teks
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pengantaran #$rideId",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.place,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                locationName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12, // Ukuran teks dikecilkan
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DasboardTemplate(initialPageIndex: 1),
                            ),
                          );
                        },
                        child: const Text(
                          'Selengkapnya',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 156, 144),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }

  Widget _buildCurrentOrderanContent(
      BuildContext context, GetCurrentOrderanState state) {
    if (state is GetCurrentOrderanLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetCurrentOrderanLoaded) {
      return _buildLoadedCurrentOrderanContent(state);
    } else if (state is GetCurrentOrderanFailure) {
      if (state.errorMessage == "Unauthorized") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/onBoarding');
        });
      }
      if (state.errorMessage == "no_current_orderan") {
        return Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Aktifitas Pesanan Aktif',
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'images/no_data.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tidak ada pesanan aktif",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ]);
      }
      return const Center(
        child: Text(''),
      );
    } else {
      return const Center(
        child: Text('...'),
      );
    }
  }

  Widget _buildLoadedCurrentOrderanContent(GetCurrentOrderanLoaded state) {
    final orderId = state.model.id;
    final orderLat = state.model.lat;
    final orderLong = state.model.long;

    return FutureBuilder<String>(
      future: _convertLatLngToAddress(orderLat, orderLong),
      builder: (context, snapshot) {
        String locationName = "Loading...";
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            locationName = snapshot.data!;
          } else if (snapshot.hasError) {
            locationName = "Failed to get location";
          }
        }

        return Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Aktifitas Pesanan Aktif',
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
          SizedBox(
            width: double.infinity,
            child: Card(
              color: const Color(0xFF1E282C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Tambahkan Gambar di sisi kiri
                        Image.asset(
                          'images/car_order.png', // Ganti dengan path gambar yang sesuai
                          width: 45, // Sesuaikan ukuran gambar sesuai kebutuhan
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                            width: 10), // Jarak antara gambar dan teks
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pesanan #$orderId",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.place,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                locationName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12, // Ukuran teks dikecilkan
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DasboardTemplate(initialPageIndex: 2),
                            ),
                          );
                        },
                        child: const Text(
                          'Selengkapnya',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 156, 144),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
