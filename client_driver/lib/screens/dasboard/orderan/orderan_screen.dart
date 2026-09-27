import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:airport_taxi_sharing_driver_client/blocs/driver/updateLocation/update_location_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/acceptOrderan/accept_orderan_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/cancelOrderan/cancel_orderan_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/getCurrentOrderan/get_current_orderan_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/rejectOrderan/reject_orderan_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/sendMessage/send_message_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/sendReview/send_review_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/orderan/updateStatusOrderan/update_status_orderan_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/dasboard/loading.dart';
import 'package:airport_taxi_sharing_driver_client/components/loading_data_background.dart';
import 'package:airport_taxi_sharing_driver_client/const.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/Cancel_orderan_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/accept_orderan_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/reject_orderan_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/send_message_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/send_review_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_location_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_status_orderan_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/get_current_orderan_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/errorScreen/error_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/orderan/no_current_orderan.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:slide_to_act/slide_to_act.dart';

import '../../../components/confirmation_bottom_sheet.dart';

class Orderan extends StatefulWidget {
  const Orderan({super.key});

  @override
  State<Orderan> createState() => _OrderanState();
}

class _OrderanState extends State<Orderan> {
  final Location _locationController = Location();
  String locationAddress = "";
  String? address;

  String order_id = "";
  int? _statusOrderan;
  double _rating = 0;
  String _review = '';
  String estimatedCost = "";

  late GoogleMapController _mapController;
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng? _currentP;
  LatLng? _selectedP;
  final LatLng _supadioAirport = const LatLng(-0.150977, 109.403808);

  BitmapDescriptor markerIconCustomer = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconTaxi = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconRideTaxi = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconAirport = BitmapDescriptor.defaultMarker;

  late Future<Map<String, dynamic>> _futureEstimateDistanceAndDuration =
      Future.value({});

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    addCustomCustomerIcon();
    addCustomRideIcon();
    addCustomTaxiIcon();
    super.initState();
    // _initializeLocationTracking();
    getLocationUpdates().then(
      (_) => getCurrentLocation().then((currentLocation) {
        _currentP = currentLocation;
        if (_selectedP != null && _statusOrderan != null) {
          _getAddressFromLatLng(_selectedP!.latitude, _selectedP!.longitude);
          if (_statusOrderan == 3) {
            print('Status Orderan: $_statusOrderan');

            getPolylinePoints(_currentP!, _supadioAirport).then((coordinates) {
              generatePolyLineFromPoints(coordinates);
            });
            _futureEstimateDistanceAndDuration =
                getEstimateDistanceAndDuration(_currentP!, _supadioAirport);
          } else {
            getPolylinePoints(_currentP!, _selectedP!).then((coordinates) {
              generatePolyLineFromPoints(coordinates);
            });
            _futureEstimateDistanceAndDuration =
                getEstimateDistanceAndDuration(_currentP!, _selectedP!);
          }
        }
        _loadData();
      }),
    );
    _loadData();

    // Add Firebase Messaging listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification?.title == "Pesan dari Customer") {
        _showReceivedMessageModal(
            context, message.notification?.body ?? 'Pesan tidak ditemukan');
      } else if (message.notification?.title == "Perjalanan selesai") {
        if (message.data.isNotEmpty) {
          String? orderId = message.data['orderId'];
          if (orderId != null) {
            _showEndJourneyBottomSheet(orderId, estimatedCost);
          }
        }
      }
      _loadData();
    });
  }

  Future<Map<String, dynamic>> getEstimateDistanceAndDuration(
    LatLng origin,
    LatLng destination,
  ) async {
    String apiKey = 'AIzaSyBo8MhxZIYfbX9exFOGhOuz-PnoVRwgvLY';
    Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$apiKey',
    );

    final response = await http.get(url);

    print("Memanggil Google Maps Directions API...");

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

  void _showReceivedMessageModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E282C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.message, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                'Pesan Diterima',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pesan ini dikirimkan oleh Customer dari pemesanan Taksi Anda.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Text(
                '"$message"',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 20),
              const Text(
                '* Pesan ini akan hilang jika ditutup',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Tutup', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

      if (_statusOrderan == 3) {
        // Jika status orderan adalah 3, buat polyline dari currentP ke _supadioAirport
        getPolylinePoints(_currentP!, _supadioAirport).then((coordinates) {
          generatePolyLineFromPoints(coordinates);
        });
        _futureEstimateDistanceAndDuration =
            getEstimateDistanceAndDuration(_currentP!, _supadioAirport);
      } else {
        // Jika status orderan bukan 3, buat polyline dari currentP ke selectedP
        getPolylinePoints(_currentP!, _selectedP!).then((coordinates) {
          generatePolyLineFromPoints(coordinates);
        });
        _futureEstimateDistanceAndDuration =
            getEstimateDistanceAndDuration(_currentP!, _selectedP!);
      }

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
            bearing: 90,
          ),
        ),
      );

      // final requestModelLocation = UpdateLocationRequestModel(
      //   latitude: _currentP!.latitude,
      //   longitude: _currentP!.longitude,
      // );

      // context.read<UpdateLocationBloc>().add(
      //       LoadUpdateLocationEvent(request: requestModelLocation),
      //     );
    });
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData currentLocation = await _locationController.getLocation();
    return LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }

  // Future<void> addCustomAirportIcon() async {
  //   final ByteData imageData = await rootBundle.load("images/airport.png");
  //   final ui.Codec codec = await ui.instantiateImageCodec(
  //     imageData.buffer.asUint8List(),
  //     targetWidth: 100,
  //     targetHeight: 100,
  //   );
  //   final ui.FrameInfo frameInfo = await codec.getNextFrame();
  //   final ByteData? byteData =
  //       await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  //   final Uint8List resizedImageData = byteData!.buffer.asUint8List();

  //   final BitmapDescriptor bitmapDescriptor =
  //       BitmapDescriptor.fromBytes(resizedImageData);
  //   setState(() {
  //     markerIconAirport = bitmapDescriptor;
  //   });
  // }

  Future<void> addCurrentPositionCustomIcon() async {
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

  Future<void> addCustomCustomerIcon() async {
    final ByteData imageData =
        await rootBundle.load("images/customer_location.png");
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: 75,
      targetHeight: 75,
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

  Future<void> addCustomRideIcon() async {
    final ByteData imageData = await rootBundle.load("images/pin-map.png");
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
      markerIconRideTaxi = bitmapDescriptor;
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

  Future<List<LatLng>> getPolylinePoints(
      LatLng start, LatLng? destination) async {
    print(
        "haloo ini calling polyline api...[latlng start : ${start}, ${destination}]");
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

  Future<void> _loadData() async {
    context.read<GetCurrentOrderanBloc>().add(LoadGetCurrentOrderanEvent());

    final updateLocationRequestModel = UpdateLocationRequestModel(
      latitude: _currentP!.latitude,
      longitude: _currentP!.longitude,
    );

    context.read<UpdateLocationBloc>().add(
          LoadUpdateLocationEvent(request: updateLocationRequestModel),
        );
  }

  Future<void> _refreshData() async {
    _loadData();
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
          child: Column(
            children: [
              BlocBuilder<GetCurrentOrderanBloc, GetCurrentOrderanState>(
                builder: (context, state) {
                  return _buildGetCurrentOrderanContent(context, state);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGetCurrentOrderanContent(
      BuildContext context, GetCurrentOrderanState state) {
    if (state is GetCurrentOrderanLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetCurrentOrderanLoaded) {
      _selectedP = LatLng(state.model.lat, state.model.long);
      _statusOrderan = state.model.status;

      return _buildLoadedCurrentOrderContent(state);
    } else if (state is GetCurrentOrderanFailure) {
      print(state.errorMessage);
      if (state.errorMessage == "Unauthorized") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/onBoarding');
        });
      } else if (state.errorMessage == "no_current_orderan") {
        return const NoCurrentOrderan();
      }
      return SomethingError(onNavigate: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DasboardTemplate(initialPageIndex: 2),
          ),
        );
      });
    } else {
      return const Center(
        child: Text('Memuat Data...'),
      );
    }
  }

  Widget _buildLoadedCurrentOrderContent(GetCurrentOrderanLoaded state) {
    final String id = state.model.id;
    order_id = id;
    final LatLng customerOrderLatLng =
        LatLng(state.model.lat, state.model.long);

    final int status = state.model.status;
    final Customer customer = state.model.customer;
    final Ride ride = state.model.ride;

    final int pickupRadius = ride.pickupRadius;
    final double rideLat = ride.lat;
    final double rideLong = ride.long;
    estimatedCost = state.model.cost;

    return Stack(children: [
      Column(children: [
        Stack(children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFF1E282C)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  if (_currentP != null)
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _currentP!,
                        zoom: 14.0,
                        bearing: 90,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer()),
                      },
                      rotateGesturesEnabled: true,
                      polylines: Set<Polyline>.of(polylines.values),
                      markers: {
                        Marker(
                            markerId: const MarkerId('orderLocation'),
                            position: customerOrderLatLng,
                            infoWindow: const InfoWindow(
                              title: 'Lokasi Penjemputan Pesanan',
                            ),
                            icon: markerIconCustomer),
                        Marker(
                          markerId: const MarkerId('rideLocation'),
                          position: LatLng(rideLat, rideLong),
                          infoWindow: const InfoWindow(
                            title: 'Lokasi Pengantaran',
                          ),
                          icon: markerIconRideTaxi,
                        ),
                        Marker(
                            markerId: const MarkerId('currentLocation'),
                            position: _currentP!,
                            infoWindow: const InfoWindow(
                              title: 'Posisi Anda Saat Ini',
                            ),
                            icon: markerIconTaxi),
                      },
                      circles: {
                        Circle(
                          circleId: const CircleId("pickupRadius"),
                          center: LatLng(rideLat, rideLong),
                          radius: pickupRadius.toDouble(),
                          strokeColor: Colors.blue,
                          strokeWidth: 1,
                          fillColor: Colors.blue.withOpacity(0.1),
                        ),
                      },
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                color: Color(0xFF1E282C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ),
        ]),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Color(0xFF1E282C),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris pertama: ID dan tindakan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#$id',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      BlocListener<SendMessageBloc, SendMessageState>(
                        listener: (context, state) {
                          if (state is SendMessageFailure) {
                            if (state.errorMessage == "Unauthorized") {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Get.toNamed('/onBoarding');
                              });
                            }
                            AnimatedSnackBar.removeAll();
                            AnimatedSnackBar.material(
                              'Pesan gagal dikirimkan!',
                              type: AnimatedSnackBarType.error,
                              mobileSnackBarPosition:
                                  MobileSnackBarPosition.bottom,
                            ).show(context);
                          } else if (state is SendMessageSuccess) {
                            AnimatedSnackBar.removeAll();
                            AnimatedSnackBar.material(
                              'Pesan berhasil dikirimkan!',
                              type: AnimatedSnackBarType.success,
                              mobileSnackBarPosition:
                                  MobileSnackBarPosition.bottom,
                            ).show(context);
                          }
                        },
                        child: IconButton(
                          icon: const Icon(Icons.message, color: Colors.white),
                          onPressed: () {
                            _showMessageModal(context, id);
                          },
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (String value) {
                          if (value == 'Detail Customer') {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return _buildCustomerDetailSheet(
                                    context, customer, status);
                              },
                            );
                          } else if (value == 'Detail Pesanan') {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return _buildOrderanDetailSheet(
                                    context, state.model);
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return {'Detail Customer', 'Detail Pesanan'}
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Baris kedua: Alamat dan status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address ?? 'Loading...',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14.5,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _getStatusText(status),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Estimasi berdasarkan status
                  if (status == 0 || status == 1 || status == 2)
                    const Text(
                      'Estimasi penjemputan',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    )
                  else if (status == 3)
                    const Text(
                      'Estimasi ketibaan di bandara',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  const SizedBox(height: 20),
                  if (_currentP != null && _selectedP != null)
                    FutureBuilder<Map<String, dynamic>>(
                      future: _futureEstimateDistanceAndDuration,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E282C),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.route,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${directionData['distance']} Km',
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
                            ],
                          );
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 25),

              // Baris ketiga: Tombol aksi
              Align(
                alignment: Alignment.centerRight,
                child: _buildActionButtons(context, status, id),
              ),
              const SizedBox(height: 10),
              if (status == 1 || status == 2 || status == 3)
                BlocListener<CancelOrderanBloc, CancelOrderanState>(
                  listener: (context, state) {
                    if (state is CancelOrderanFailure) {
                      if (state.errorMessage == "Unauthorized") {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Get.toNamed('/onBoarding');
                        });
                      }
                      AnimatedSnackBar.removeAll();
                      AnimatedSnackBar.material(
                        'Data pesanan gagal dibatalkan!',
                        type: AnimatedSnackBarType.error,
                        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                      ).show(context);
                      _loadData();
                    }
                    if (state is CancelOrderanSuccess) {
                      AnimatedSnackBar.removeAll();
                      AnimatedSnackBar.material(
                        'Data pesanan berhasil dibatalkan',
                        type: AnimatedSnackBarType.success,
                        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                      ).show(context);
                      _loadData();
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: SlideAction(
                      onSubmit: () {
                        final cancelOrderanRequestModel =
                            CancelOrderanRequestModel(orderId: id);
                        context.read<CancelOrderanBloc>().add(
                              LoadCancelOrderanEvent(
                                  request: cancelOrderanRequestModel),
                            );
                        return null;
                      },
                      innerColor: Colors.white,
                      outerColor: const ui.Color.fromARGB(255, 219, 41, 28),
                      elevation: 2,
                      borderRadius: 20,
                      alignment: Alignment.center,
                      height: 65,
                      child: const Center(
                        child: Text(
                          'Batalkan Pesanan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
      ]),
      BlocBuilder<RejectOrderanBloc, RejectOrderanState>(
        builder: (context, state) {
          if (state is RejectOrderanLoading) {
            return const LoadingModal();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      BlocBuilder<AcceptOrderanBloc, AcceptOrderanState>(
        builder: (context, state) {
          if (state is AcceptOrderanLoading) {
            return const LoadingModal();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      BlocBuilder<UpdateStatusOrderanBloc, UpdateStatusOrderanState>(
        builder: (context, state) {
          if (state is UpdateStatusOrderanLoading) {
            return const LoadingModal();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      BlocBuilder<SendMessageBloc, SendMessageState>(
        builder: (context, state) {
          if (state is SendMessageLoading) {
            return const LoadingModal();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      BlocBuilder<SendReviewBloc, SendReviewState>(
        builder: (context, state) {
          if (state is SendReviewLoading) {
            return const LoadingModal();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    ]);
  }

  void _showMessageModal(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String message = '';
        return AlertDialog(
          backgroundColor: const Color(0xFF1E282C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Kirim Pesan ke Customer',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            height: 150,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      message = value;
                    },
                    style: const TextStyle(color: Colors.white),
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Tulis pesan Anda di sini...",
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Kirim', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (message.trim().isEmpty) {
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Pesan Tidak boleh kosong!',
                    type: AnimatedSnackBarType.error,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                } else {
                  _sendMessage(id, message);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _sendMessage(String orderId, String message) {
    final requestModelMessage =
        SendMessageRequestModel(orderId: orderId, message: message);

    context.read<SendMessageBloc>().add(
          LoadSendMessageEvent(request: requestModelMessage),
        );
  }

  Widget _buildCustomerDetailSheet(
      BuildContext context, Customer customer, int status) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E282C),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                'Detail Customer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // if (status != 0) ...[
            Center(
              child: ClipOval(
                child: Image.network(
                  customer.photo,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // ],
            const SizedBox(height: 20),
            // Menambahkan average rating dan ikon bintang
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 22),
                const SizedBox(width: 10),
                Text(
                  customer.averageRating.toStringAsFixed(
                      1), // Menampilkan rating dengan 1 desimal
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                const Text(
                  '/ 5',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  customer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // if (status != 0) ...[
            Row(
              children: [
                const Icon(Icons.email, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  customer.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  '(+62) ${customer.phoneNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ],
          // ],
        ),
      ),
    );
  }

  Widget _buildOrderanDetailSheet(
      BuildContext context, GetCurrentOrderanResponseModel model) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E282C),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detail Pesanan Taksi Bandara Supadio #${model.id}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, size: 24, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                    child: Text('Lokasi Penjemputan \n$address',
                        style: const TextStyle(color: Colors.white))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.info, size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Status Pesanan\n${_getStatusText(model.status)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.info, size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Status Pengantaran\n${_getStatusText2(model.ride.rideStatus)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.directions_car, size: 24, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Jarak Lokasi Pesanan Anda ke Bandara \n${(model.customerToAirportDistance / 1000).toStringAsFixed(1)} Km',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money,
                          size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Tarif Per Km\n${model.farePerKm},00',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.money, size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Estimasi Biaya\n${model.cost},00',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> _getLocationName(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String name = place.name ?? '';
        String street = place.street ?? '';
        String subLocality = place.subLocality ?? '';
        String locality = place.locality ?? '';
        String administrativeArea = place.administrativeArea ?? '';
        String postalCode = place.postalCode ?? '';
        String country = place.country ?? '';

        return '$name, $street, $subLocality, $locality, $administrativeArea, $postalCode, $country';
      } else {
        return 'Tidak diketahui';
      }
    } catch (e) {
      print(e);
      return 'Tidak diketahui';
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Sedang proses (Menunggu konfirmasi driver)';
      case 1:
        return 'Pesanan diterima oleh \nDriver (Anda)';
      case 2:
        return 'Dalam Perjalanan (Menjemput Customer)';
      case 3:
        return 'Menuju bandara';
      case 4:
        return 'Selesai';
      case 5:
        return 'Pesanan dibatalkan oleh customer';
      case 6:
        return 'Pesanan dibatalkan oleh driver';
      default:
        return 'Tidak Diketahui';
    }
  }

  String _getStatusText2(int status) {
    switch (status) {
      case 0:
        return 'Sedang proses';
      case 1:
        return 'Selesai mengantar';
      case 2:
        return 'Batal';
      case 3:
        return 'Selesai';
      default:
        return 'Tidak Diketahui';
    }
  }

  Widget _buildActionButtons(BuildContext context, int status, String id) {
    switch (status) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocListener<RejectOrderanBloc, RejectOrderanState>(
              listener: (context, state) {
                if (state is RejectOrderanFailure) {
                  if (state.errorMessage == "Unauthorized") {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Get.toNamed('/onBoarding');
                    });
                  }
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Data pesanan gagal ditolak!',
                    type: AnimatedSnackBarType.error,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  _loadData();
                }
                if (state is RejectOrderanSuccess) {
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Data pesanan berhasil ditolak',
                    type: AnimatedSnackBarType.success,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  _loadData();
                }
              },
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    CustomBottomSheet.displayConfirmationBottomSheet(
                      context,
                      'Konfirmasi Penolakan Pesanan Taksi. Id Pesanan : #$id',
                      'Apakah Anda yakin ingin menolak pesanan taksi ini?',
                      'images/check.png',
                      () {
                        Navigator.pop(context);
                        final rejectOrderanRequestModel =
                            RejectOrderanRequestModel(orderId: id);

                        context.read<RejectOrderanBloc>().add(
                              LoadRejectOrderanEvent(
                                  request: rejectOrderanRequestModel),
                            );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 147, 31, 31),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: const Text(
                    'Tolak Pesanan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            BlocListener<AcceptOrderanBloc, AcceptOrderanState>(
              listener: (context, state) {
                if (state is AcceptOrderanFailure) {
                  if (state.errorMessage == "Unauthorized") {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Get.toNamed('/onBoarding');
                    });
                  }
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Data pesanan gagal diterima',
                    type: AnimatedSnackBarType.error,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  _loadData();
                }
                if (state is AcceptOrderanSuccess) {
                  AnimatedSnackBar.removeAll();
                  AnimatedSnackBar.material(
                    'Data pesanan berhasil diterima',
                    type: AnimatedSnackBarType.success,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  _loadData();
                }
              },
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    CustomBottomSheet.displayConfirmationBottomSheet(
                      context,
                      'Konfirmasi Penerimaan Pesanan Taksi. Id Pesanan : #$id',
                      'Apakah Anda yakin ingin menerima pesanan taksi ini?',
                      'images/check.png',
                      () {
                        Navigator.pop(context);
                        final acceptOrderanRequestModel =
                            AcceptOrderanRequestModel(orderId: id);

                        context.read<AcceptOrderanBloc>().add(
                              LoadAcceptOrderanEvent(
                                  request: acceptOrderanRequestModel),
                            );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 156, 144),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: const Text(
                    'Terima Pesanan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      case 1:
        return BlocListener<UpdateStatusOrderanBloc, UpdateStatusOrderanState>(
          listener: (context, state) {
            if (state is UpdateStatusOrderanFailure) {
              if (state.errorMessage == "Unauthorized") {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Get.toNamed('/onBoarding');
                });
              }
              AnimatedSnackBar.removeAll();
              AnimatedSnackBar.material(
                'Data pesanan gagal diperbarui',
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
              _refreshData();
            }
            if (state is UpdateStatusOrderanSuccess) {
              AnimatedSnackBar.removeAll();
              AnimatedSnackBar.material(
                'Data pesanan berhasil diperbarui',
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
              _refreshData();
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: SlideAction(
              onSubmit: () {
                final updateStatusOrderanRequestModel =
                    UpdateStatusOrderanRequestModel(orderId: id, status: 2);

                context.read<UpdateStatusOrderanBloc>().add(
                      LoadUpdateStatusOrderanEvent(
                          request: updateStatusOrderanRequestModel),
                    );
                return null;
              },
              innerColor: Colors.white,
              outerColor: const Color.fromARGB(255, 33, 156, 144),
              elevation: 2,
              borderRadius: 20,
              alignment: Alignment.center,
              height: 65,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 156, 144),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Menjemput Customer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        );

      case 2:
        return BlocListener<UpdateStatusOrderanBloc, UpdateStatusOrderanState>(
          listener: (context, state) {
            if (state is UpdateStatusOrderanFailure) {
              if (state.errorMessage == "Unauthorized") {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Get.toNamed('/onBoarding');
                });
              }
              AnimatedSnackBar.removeAll();
              AnimatedSnackBar.material(
                'Data pesanan gagal diperbarui',
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
              _refreshData();
            }
            if (state is UpdateStatusOrderanSuccess) {
              // Remove all previous snackbars and show the success message
              AnimatedSnackBar.removeAll();
              AnimatedSnackBar.material(
                'Data pesanan berhasil diperbarui',
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);

              // Navigate to dashboard with page 3 as the initial index
              Navigator.of(context)
                  .pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      const DasboardTemplate(initialPageIndex: 2),
                ),
              )
                  .then((_) {
                // After reaching page 3, navigate back to page 2
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DasboardTemplate(initialPageIndex: 2),
                  ),
                );
              });
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: SlideAction(
              onSubmit: () {
                final updateStatusOrderanRequestModel =
                    UpdateStatusOrderanRequestModel(orderId: id, status: 3);

                context.read<UpdateStatusOrderanBloc>().add(
                      LoadUpdateStatusOrderanEvent(
                          request: updateStatusOrderanRequestModel),
                    );
                Navigator.of(context)
                    .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DasboardTemplate(initialPageIndex: 2),
                  ),
                )
                    .then((_) {
                  // After reaching page 3, navigate back to page 2
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          const DasboardTemplate(initialPageIndex: 2),
                    ),
                  );
                });
                return null;
              },
              innerColor: Colors.white,
              outerColor: const Color.fromARGB(255, 33, 156, 144),
              elevation: 2,
              borderRadius: 20,
              alignment: Alignment.center,
              height: 65,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 156, 144),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Menuju bandara',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        );

      case 3:
        return BlocListener<UpdateStatusOrderanBloc, UpdateStatusOrderanState>(
          listener: (context, state) {
            if (state is UpdateStatusOrderanFailure) {
              if (state.errorMessage == "Unauthorized") {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Get.toNamed('/onBoarding');
                });
              }
              AnimatedSnackBar.removeAll();
              AnimatedSnackBar.material(
                'Data pesanan gagal diselesaikan',
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
              _loadData();
            }
            if (state is UpdateStatusOrderanSuccess) {
              AnimatedSnackBar.removeAll();
              AnimatedSnackBar.material(
                'Data pesanan berhasil diselesaikan',
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
              _loadData();
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: SlideAction(
              onSubmit: () {
                final updateStatusOrderanRequestModel =
                    UpdateStatusOrderanRequestModel(orderId: id, status: 4);

                context.read<UpdateStatusOrderanBloc>().add(
                      LoadUpdateStatusOrderanEvent(
                          request: updateStatusOrderanRequestModel),
                    );
                return null;
              },
              innerColor: Colors.white,
              outerColor: const Color.fromARGB(255, 33, 156, 144),
              elevation: 2,
              borderRadius: 20,
              alignment: Alignment.center,
              height: 65,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 33, 156, 144),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Selesai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _showEndJourneyBottomSheet(String orderId, String estimatedCost) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text(
                    'Perjalanan Selesai #$orderId',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Berikut harga perjalanan yang harus customer bayar secara tunai sesuai perhitungan aplikasi. Berikan rating dan ulasan Anda kepada customer jika berkenan :)',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _rating = rating;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Tulis ulasan Anda (opsional)',
                    ),
                    maxLines: 3,
                    onChanged: (text) {
                      _review = text;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Estimasi Harga: $estimatedCost,00',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocListener<SendReviewBloc, SendReviewState>(
                        listener: (context, state) {
                          if (state is SendReviewFailure) {
                            if (state.errorMessage == "Unauthorized") {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Get.toNamed('/onBoarding');
                              });
                            }
                            AnimatedSnackBar.removeAll();
                            AnimatedSnackBar.material(
                              'Data review gagal dikirimkan!',
                              type: AnimatedSnackBarType.error,
                              mobileSnackBarPosition:
                                  MobileSnackBarPosition.bottom,
                            ).show(context);
                          }
                          if (state is SendReviewSuccess) {
                            Navigator.pop(context);
                            AnimatedSnackBar.removeAll();
                            AnimatedSnackBar.material(
                              'Data review berhasil dikirimkan!',
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
                              if (_rating <= 0) {
                                AnimatedSnackBar.removeAll();
                                AnimatedSnackBar.material(
                                  'rating tidak dapat dikosongkan!',
                                  type: AnimatedSnackBarType.error,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                              } else {
                                print("heloooooo");
                                final sendReviewRequestModel =
                                    SendReviewRequestModel(
                                        orderId: orderId,
                                        rating: _rating,
                                        review: _review);

                                context.read<SendReviewBloc>().add(
                                      LoadSendReviewEvent(
                                          request: sendReviewRequestModel),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 33, 156, 144),
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
