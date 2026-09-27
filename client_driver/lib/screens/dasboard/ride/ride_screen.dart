import 'dart:async';
import 'package:airport_taxi_sharing_driver_client/blocs/driver/updateLocation/update_location_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/ride/cancelRide/cancel_ride_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/ride/completeAndCloseRide/complete_and_close_ride_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/ride/completeRide/complete_ride_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/ride/getCurrentRide/get_current_ride_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/confirmation_bottom_sheet.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading_data_background.dart';
import 'package:airport_taxi_sharing_driver_client/const.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/cancel_ride_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/complete_and_close_ride_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/complete_ride_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_location_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/errorScreen/error_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/ride/add_ride_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/ride/full_map_screen.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;

import '../../../components/dasboard/loading.dart';

class Ride extends StatefulWidget {
  const Ride({super.key});

  @override
  State<Ride> createState() => _RideState();
}

class _RideState extends State<Ride> {
  final Location _locationController = Location();

  double latitude = 0;
  double longitude = 0;
  String? address;

  LatLng? _currentP;
  LatLng? _selectedP;

  Map<PolylineId, Polyline> polylines = {};

  late GoogleMapController _mapController;

  StreamSubscription<Position>? _positionStreamSubscription;

  // late Future<Map<String, dynamic>> _futureEstimateDistanceAndDuration;
  late Future<Map<String, dynamic>> _futureEstimateDistanceAndDuration =
      Future.value({});

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  BitmapDescriptor markerRideLocationIcon = BitmapDescriptor.defaultMarker;

  // marker icon

  Future<void> addCustomIcon() async {
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
      markerIcon = bitmapDescriptor;
    });
  }

  Future<void> addCustomRideLocationIcon() async {
    final ByteData imageData = await rootBundle.load("images/pin-map.png");
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: 90,
      targetHeight: 90,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();

    final BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.fromBytes(resizedImageData);
    setState(() {
      markerRideLocationIcon = bitmapDescriptor;
    });
  }

  @override
  void initState() {
    addCustomIcon();
    addCustomRideLocationIcon();
    super.initState();
    getLocationUpdates().then(
      (_) => getCurrentLocation().then((currentLocation) {
        _currentP = currentLocation;
        print(
            "ini lho selected p nya :L ${_selectedP}, ini current p nya : ${_currentP}");
        if (_selectedP != null) {
          getPolylinePoints(_currentP!, _selectedP!).then((coordinates) {
            generatePolyLineFromPoints(coordinates);
          });
          _futureEstimateDistanceAndDuration = getEstimateDistanceAndDuration();
          _getAddressFromLatLng(_selectedP!.latitude, _selectedP!.longitude);
        }
        _loadData();
      }),
    );
    _loadData();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    ).listen((Position position) async {
      setState(() {
        _currentP = LatLng(position.latitude, position.longitude);
      });

      getPolylinePoints(_currentP!, _selectedP!).then((coordinates) {
        generatePolyLineFromPoints(coordinates);
      });
      _futureEstimateDistanceAndDuration = getEstimateDistanceAndDuration();

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
            bearing: position.heading,
          ),
        ),
      );

      final requestModelLocation = UpdateLocationRequestModel(
        latitude: _currentP!.latitude,
        longitude: _currentP!.longitude,
      );

      context.read<UpdateLocationBloc>().add(
            LoadUpdateLocationEvent(request: requestModelLocation),
          );
    });
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData currentLocation = await _locationController.getLocation();
    return LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }

  Future<List<LatLng>> getPolylinePoints(
      LatLng start, LatLng? destination) async {
    print("haloo ini calling polyline api...");
    if (destination == null) return [];
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _loadData() async {
    // Your data loading logic here
    context.read<GetCurrentRideBloc>().add(LoadGetCurrentRideEvent());
    final updateLocationRequestModel = UpdateLocationRequestModel(
      latitude: _currentP!.latitude,
      longitude: _currentP!.longitude,
    );

    context.read<UpdateLocationBloc>().add(
          LoadUpdateLocationEvent(request: updateLocationRequestModel),
        );
  }

  Future<void> _refreshData() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DasboardTemplate(initialPageIndex: 1),
      ),
    );
  }

  Future<void> _getAddressFromLatLng(double lat, double long) async {
    const String apiKey = 'AIzaSyBo8MhxZIYfbX9exFOGhOuz-PnoVRwgvLY';
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    print("haloo ini calling get address api...");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String formattedAddress = data['results'][0]['formatted_address'];
      setState(() {
        address = formattedAddress;
      });
    } else {
      throw Exception('Failed to load address');
    }
  }

  Future<Map<String, dynamic>> getEstimateDistanceAndDuration() async {
    String apiKey = 'AIzaSyBo8MhxZIYfbX9exFOGhOuz-PnoVRwgvLY';

    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentP!.latitude},${_currentP!.longitude}&destination=${_selectedP!.latitude},${_selectedP!.longitude}&mode=driving&key=$apiKey');

    final response = await http.get(url);

    print("haloo ini calling direction api...");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["status"] == "OK") {
        int distance = data["routes"][0]["legs"][0]["distance"]["value"];
        int duration = data["routes"][0]["legs"][0]["duration"]["value"];
        int minutes = (duration / 60).round();
        double kilometers = (distance / 1000);
        String formattedKilometers = kilometers.toStringAsFixed(1);

        return {
          'distance': formattedKilometers,
          'duration': minutes,
        };
      } else {
        throw Exception('Failed to get directions. Status: ${data["status"]}');
      }
    } else {
      throw Exception('Failed to get directions');
    }
  }

  String _rideStatusToString(int status) {
    switch (status) {
      case 0:
        return "Dalam perjalanan";
      case 1:
        return "Selesai mengantar";
      case 2:
        return "Tidak selesai (Batal)";
      default:
        return "Status tidak dikenal";
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                BlocBuilder<GetCurrentRideBloc, GetCurrentRideState>(
                  builder: (context, state) {
                    return _buildGetCurrentRideContent(context, state);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGetCurrentRideContent(
      BuildContext context, GetCurrentRideState state) {
    if (state is GetCurrentRideLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetCurrentRideLoaded) {
      _selectedP = LatLng(state.model.lat, state.model.long);
      return _buildLoadedCurrentRideContent(state);
    } else if (state is GetCurrentRideFailure) {
      if (state.errorMessage == "Unauthorized") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/onBoarding');
        });
      } else if (state.errorMessage == "no_current_ride") {
        return const AddRide();
      }
      return SomethingError(onNavigate: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DasboardTemplate(initialPageIndex: 1),
          ),
        );
      });
    } else {
      return const Center(
        child: Text('Memuat Data...'),
      );
    }
  }

  Widget _buildLoadedCurrentRideContent(GetCurrentRideLoaded state) {
    final double lat = state.model.lat;
    final double long = state.model.long;
    final String rideId = state.model.id;
    final int pickupRadius = state.model.pickupRadius;
    final int rideStatus = state.model.rideStatus;
    final String createDateTime = state.model.createDatetime;
    final String updateDateTime = state.model.updateDatetime;

    // _selectedP = LatLng(lat, long);

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Pengantaran customer dari bandara yang \nsedang berlangsung',
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
          Card(
            elevation: 4.0,
            color: const Color(0xFF1E282C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Informasi Pengantaran ',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextSpan(
                            text: '#$rideId',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _buildAddressRow(address ?? 'Loading...'),
                    const SizedBox(height: 10.0),
                    _buildInfoRow('Radius Pengantaran', '$pickupRadius meter'),
                    _buildInfoRow('Status', _rideStatusToString(rideStatus)),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.edit,
                              size: 16, // Ukuran ikon yang lebih kecil
                            ),
                            const SizedBox(width: 5),
                            Text(
                              createDateTime,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              updateDateTime,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    if (rideStatus == 0) ...[
                      Row(
                        children: [
                          BlocListener<CompleteRideBloc, CompleteRideState>(
                            listener: (context, state) {
                              if (state is CompleteRideFailure) {
                                if (state.errorMessage == "Unauthorized") {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    Get.toNamed('/onBoarding');
                                  });
                                }
                                AnimatedSnackBar.removeAll();
                                AnimatedSnackBar.material(
                                  'Gagal memperbarui status pengantaran!',
                                  type: AnimatedSnackBarType.error,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                                _loadData();
                              }
                              if (state is CompleteRideSuccess) {
                                AnimatedSnackBar.removeAll();
                                AnimatedSnackBar.material(
                                  'Berhasil memperbarui status pengantaran!',
                                  type: AnimatedSnackBarType.success,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                                _loadData();
                              }
                            },
                            child: Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  CustomBottomSheet
                                      .displayConfirmationBottomSheet(
                                    context,
                                    'Konfirmasi Pembaruan Status Pengantaran #$rideId',
                                    'Apakah Anda yakin untuk memperbarui status pengantaran ini?',
                                    'images/check.png',
                                    () {
                                      Navigator.pop(context);
                                      final completeRideRequestModel =
                                          CompleteRideRequestModel(
                                              rideId: rideId);

                                      context.read<CompleteRideBloc>().add(
                                            LoadCompleteRideEvent(
                                                request:
                                                    completeRideRequestModel),
                                          );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 33, 156, 144),
                                  padding: const EdgeInsets.all(5.0),
                                ),
                                child: const Text(
                                  'Selesai \nMengantar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          BlocListener<CancelRideBloc, CancelRideState>(
                            listener: (context, state) {
                              if (state is CancelRideFailure) {
                                if (state.errorMessage == "Unauthorized") {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    Get.toNamed('/onBoarding');
                                  });
                                }
                                AnimatedSnackBar.removeAll();
                                AnimatedSnackBar.material(
                                  'Data pengantaran gagal dibatalkan!',
                                  type: AnimatedSnackBarType.error,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DasboardTemplate(
                                            initialPageIndex: 1),
                                  ),
                                );
                              }
                              if (state is CancelRideSuccess) {
                                AnimatedSnackBar.removeAll();
                                AnimatedSnackBar.material(
                                  'Data pengantaran berhasil dibatalkan!',
                                  type: AnimatedSnackBarType.success,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DasboardTemplate(
                                            initialPageIndex: 1),
                                  ),
                                );
                              }
                            },
                            child: Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  CustomBottomSheet
                                      .displayConfirmationBottomSheet(
                                    context,
                                    'Konfirmasi Pembatalan Data Pengantaran #$rideId',
                                    'Apakah Anda yakin untuk membatalkan pengantaran ini? ',
                                    'images/check.png',
                                    () {
                                      Navigator.pop(context);
                                      final cancelRideRequestModel =
                                          CancelRideRequestModel(
                                              rideId: rideId);

                                      context.read<CancelRideBloc>().add(
                                            LoadCancelRideEvent(
                                                request:
                                                    cancelRideRequestModel),
                                          );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade800,
                                  padding: const EdgeInsets.all(5.0),
                                ),
                                child: const Text(
                                  'Batalkan Pengantaran',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (rideStatus == 1) ...[
                      Row(
                        children: [
                          BlocListener<CompleteAndCloseRideBloc,
                              CompleteAndCloseRideState>(
                            listener: (context, state) {
                              if (state is CompleteAndCloseRideFailure) {
                                if (state.errorMessage == "Unauthorized") {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    Get.toNamed('/onBoarding');
                                  });
                                }
                                AnimatedSnackBar.removeAll();
                                AnimatedSnackBar.material(
                                  'Data pengantaran gagal diselesaikan!',
                                  type: AnimatedSnackBarType.error,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                                _loadData();
                              }
                              if (state is CompleteAndCloseRideSuccess) {
                                AnimatedSnackBar.removeAll();
                                AnimatedSnackBar.material(
                                  'Data pengantaran berhasil diselesaikan!',
                                  type: AnimatedSnackBarType.success,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                                _loadData();
                              }
                            },
                            child: Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  CustomBottomSheet
                                      .displayConfirmationBottomSheet(
                                    context,
                                    'Konfirmasi Penyelesaian Data Pengantaran #$rideId',
                                    'Apakah Anda yakin untuk menyelesaikan pengantaran ini? Anda tidak dapat menerima pesanan baru dari pengantaran ini!',
                                    'images/check.png',
                                    () {
                                      Navigator.pop(context);
                                      final completeAndCloseRideRequestModel =
                                          CompleteAndCloseRideRequestModel(
                                              rideId: rideId);

                                      context
                                          .read<CompleteAndCloseRideBloc>()
                                          .add(
                                            LoadCompleteAndCloseRideEvent(
                                                request:
                                                    completeAndCloseRideRequestModel),
                                          );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 33, 156, 144),
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                child: const Text(
                                  'Selesaikan Pengantaran',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                  ]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Map',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.fullscreen_outlined),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullMap(
                        currentLocation: _currentP!,
                        destinationLocation: _selectedP,
                        polylines: polylines,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: const Color(0xFF1E282C),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                children: [
                  if (_currentP != null)
                    GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                          target: _currentP!, zoom: 14.0, bearing: 15),
                      polylines: Set<Polyline>.of(polylines.values),
                      // myLocationEnabled: true,
                      // myLocationButtonEnabled: true,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      circles: {
                        Circle(
                          circleId: const CircleId("pickupRadius"),
                          center: LatLng(lat, long),
                          radius: pickupRadius.toDouble(),
                          strokeColor: Colors.blue,
                          strokeWidth: 1,
                          fillColor: Colors.blue.withOpacity(0.1),
                        ),
                      },
                      rotateGesturesEnabled: true,
                      markers: Set<Marker>.of(_currentP != null
                          ? [
                              Marker(
                                markerId: const MarkerId("current position"),
                                position: _currentP!,
                                icon: markerIcon,
                                infoWindow: const InfoWindow(
                                  title: 'Lokasi Anda',
                                ),
                              ),
                              Marker(
                                markerId:
                                    const MarkerId("ride destination position"),
                                position: _selectedP!,
                                icon: markerRideLocationIcon,
                                infoWindow: const InfoWindow(
                                  title: 'Lokasi Pengantaran',
                                ),
                              ),
                            ]
                          : []),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_currentP != null && _selectedP != null)
            FutureBuilder<Map<String, dynamic>>(
              future: _futureEstimateDistanceAndDuration,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // return Text('Error: ${snapshot.error}');
                  return const Text('Error: Terdapat kesalahan!');
                } else if (!snapshot.hasData) {
                  return const Text('No data');
                } else {
                  var directionData = snapshot.data!;
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E282C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.route,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${directionData['distance']} km',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${directionData['duration']} menit',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
        ]),
      ),
      BlocBuilder<CancelRideBloc, CancelRideState>(
        builder: (context, state) {
          if (state is CancelRideLoading) {
            return const LoadingModal();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      BlocBuilder<CompleteRideBloc, CompleteRideState>(
        builder: (context, state) {
          if (state is CompleteRideLoading) {
            return const LoadingModal();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    ]);
  }

  Widget _buildAddressRow(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
