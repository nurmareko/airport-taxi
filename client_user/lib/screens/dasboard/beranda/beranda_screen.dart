// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ui' as ui;
import 'package:client_user/blocs/customer/updateTokenDevice/update_device_token_bloc.dart';
import 'package:client_user/data/models/request/update_device_token_request_model.dart';
import 'package:client_user/screens/dasboard/beranda/add_destination_location_screen.dart';
import 'package:client_user/screens/dasboard/dasboard_template_screen.dart';
import 'package:client_user/screens/dasboard/errorScreen/error_screen.dart';
import 'package:client_user/screens/dasboard/errorScreen/location_error_screen.dart';
import 'package:client_user/screens/dasboard/beranda/fulll_map_screen.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:client_user/blocs/order/getTaxisWithinRadius/get_taxis_within_radius_bloc.dart';
import 'package:client_user/blocs/customer/getCustomer/get_customer_bloc.dart';
import 'package:client_user/blocs/customer/updateLocation/update_location_bloc.dart';
import 'package:client_user/data/models/request/update_location_request_model.dart';

import 'package:client_user/utils/location_controller.dart';
import 'package:client_user/utils/location_service.dart';
import 'package:client_user/components/loading_data_background.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

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

  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor markerIconCustomer = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconTaxi = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomCustomerIcon();
    addCustomTaxiIcon();
    super.initState();
    _loadData();
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

  Future<void> addCustomCustomerIcon() async {
    final ByteData imageData =
        await rootBundle.load("images/location-mark.png");
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: 80,
      targetHeight: 80,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();

    final BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.fromBytes(resizedImageData);
    setState(() {
      markerIconCustomer = bitmapDescriptor;
    });
  }

  Future<void> addCustomTaxiIcon() async {
    final ByteData imageData = await rootBundle.load("images/transport.png");
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: 120,
      targetHeight: 120,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();

    final BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.fromBytes(resizedImageData);
    setState(() {
      markerIconTaxi = bitmapDescriptor;
    });
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
    print("hello ini token device nya : $storedDeviceToken");
    final requestModelDeviceToken =
        UpdateDeviceTokenRequestModel(deviceToken: storedDeviceToken!);

    context.read<UpdateDeviceTokenBloc>().add(
          LoadUpdateDeviceTokenEvent(request: requestModelDeviceToken),
        );

    context.read<UpdateLocationBloc>().add(
          LoadUpdateLocationEvent(request: requestModelLocation),
        );

    context.read<GetCustomerBloc>().add(LoadGetCustomer());

    context.read<GetTaxisWithinRadiusBloc>().add(LoadGetTaxisWithinRadius());
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
                          BlocBuilder<GetCustomerBloc, GetCustomerState>(
                            builder: (context, state) {
                              return _buildProfileContent(context, state);
                            },
                          ),
                          BlocBuilder<GetTaxisWithinRadiusBloc,
                              GetTaxisWithinRadiusState>(
                            builder: (context, state) {
                              return _buildMapContent(context, state);
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

  Widget _buildProfileContent(BuildContext context, GetCustomerState state) {
    if (state is GetCustomerLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetCustomerLoaded) {
      return _buildLoadedProfileContent(state);
    } else if (state is GetCustomerFailure) {
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

  Widget _buildMapContent(
      BuildContext context, GetTaxisWithinRadiusState state) {
    if (state is GetTaxisWithinRadiusLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetTaxisWithinRadiusLoaded) {
      return _buildLoadedMapContent(state);
    } else if (state is GetTaxisWithinRadiusFailure) {
      if (state.errorMessage == "Unauthorized") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/onBoarding');
        });
      }
      return const Center(child: Text(""));
    } else {
      return const Text("");
    }
  }

  Widget _buildLoadedMapContent(GetTaxisWithinRadiusLoaded state) {
    final customerLatitude = state.model.customerLocation.lat;
    final customerLongitude = state.model.customerLocation.long;
    final availableRidesCount = state.model.availableRidesCount;

    // Daftar titik-titik rides dengan menyertakan rideId
    List<Tuple3<LatLng, double, String>> ridePoints =
        state.model.rides.map((ride) {
      return Tuple3(
        LatLng(ride.lat, ride.long),
        ride.pickupRadius.toDouble(),
        ride.id,
      );
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const Text(
                'Map',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Card(
                color: const Color(0xFF1E282C), // Warna dasar card
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Membuat sudut melengkung
                ),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Menambahkan padding
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddDestination(), // Fungsi halaman
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize
                          .min, // Make the row take only the required width
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.white), // Ikon lokasi putih
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.fullscreen),
                iconSize: 30,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullMap(
                        customerLatitude: customerLatitude,
                        customerLongitude: customerLongitude,
                        ridePoints: ridePoints
                            .map((tuple) =>
                                Tuple3(tuple.item1, tuple.item2, tuple.item3))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (availableRidesCount > 0)
          Container(
            height: 300.0,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(customerLatitude, customerLongitude),
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                rotateGesturesEnabled: true,
                markers: {
                  ...ridePoints.map(
                    (tuple) => Marker(
                      markerId: MarkerId(tuple.item3),
                      position: tuple.item1,
                      icon: markerIconTaxi,
                      infoWindow: InfoWindow(
                        title: 'Lokasi Pengantaran #${tuple.item3}',
                      ),
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('customerLocation'),
                    position: LatLng(customerLatitude, customerLongitude),
                    icon: markerIconCustomer,
                    infoWindow: const InfoWindow(
                      title: 'Lokasi Anda',
                    ),
                  ),
                },
                circles: Set.from(ridePoints.map((tuple) {
                  return Circle(
                    circleId: CircleId(tuple.item1.toString()),
                    center: tuple.item1,
                    radius: tuple.item2,
                    fillColor: Colors.blue.withValues(alpha: 0.1),
                    strokeColor: Colors.blue,
                    strokeWidth: 1,
                  );
                })),
              ),
            ),
          ),
        if (availableRidesCount == 0)
          Container(
            height: 300.0,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(customerLatitude, customerLongitude),
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                rotateGesturesEnabled: true,
                markers: {
                  Marker(
                    markerId: const MarkerId('customerLocation'),
                    position: LatLng(customerLatitude, customerLongitude),
                    icon: markerIconCustomer,
                    infoWindow: const InfoWindow(
                      title: 'Lokasi Anda',
                    ),
                  ),
                },
              ),
            ),
          ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1E282C),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 3,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  availableRidesCount > 0
                      ? 'Ada $availableRidesCount driver taksi yang menuju sekitar lokasi Anda saat ini.'
                      : 'Tidak ada driver taksi yang menuju ke sekitar Anda saat ini.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedProfileContent(GetCustomerLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF1E282C),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profil Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        const DasboardTemplate(initialPageIndex: 4),
                  ));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Lihat Profil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.white54,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(state.model.photo),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.model.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.model.email,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "(+62) ${state.model.phoneNumber}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.location_on, size: 24, color: Colors.grey),
            const SizedBox(width: 5),
            Row(
              children: [
                FutureBuilder<List<Placemark>>(
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
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: true),
                              Text(
                                  '${placemark.locality}, ${placemark.administrativeArea},',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: true),
                              Text(
                                  '${placemark.country}, ${placemark.postalCode}, ${placemark.subAdministrativeArea}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: true),
                            ],
                          );
                        } else {
                          return const Text('Terjadi kesalahan...');
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ])
        ],
      ),
    );
  }
}
