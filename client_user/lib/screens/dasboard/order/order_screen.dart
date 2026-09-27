import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:airport_taxi_sharing_user_client/blocs/order/cancelOrder/cancel_order_bloc.dart';
import 'package:airport_taxi_sharing_user_client/blocs/order/getCurrentOrder/get_current_order_bloc.dart';
import 'package:airport_taxi_sharing_user_client/blocs/order/sendMessage/send_message_bloc.dart';
import 'package:airport_taxi_sharing_user_client/blocs/order/sendReview/send_review_bloc.dart';
import 'package:airport_taxi_sharing_user_client/components/confirmation_bottom_sheet.dart';
import 'package:airport_taxi_sharing_user_client/components/dasboard/loading.dart';
import 'package:airport_taxi_sharing_user_client/components/loading_data_background.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/cancel_order_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/send_message_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/send_review_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/get_current_order_response_model.dart';
import 'package:airport_taxi_sharing_user_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/dasboard/errorScreen/error_screen.dart';
import 'package:airport_taxi_sharing_user_client/screens/dasboard/order/no_current_order.screen.dart';
import 'package:animated_floating_widget/widgets/floating_widget.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart' hide Marker;

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String locationAddress = "";

  BitmapDescriptor markerIconCustomer = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconTaxi = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconRideTaxi = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconAirport = BitmapDescriptor.defaultMarker;

  late CameraPosition initialCameraPosition;

  Set<Marker> markers = {};

  double _rating = 0;
  String _review = '';

  @override
  void initState() {
    super.initState();
    addCustomCustomerIcon();
    addCustomRideIcon();
    addCustomTaxiIcon();
    addCustomAirportIcon();
    _loadData();

    // Add Firebase Messaging listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification?.title == "update-latlng") {
        _showUpdatePositionDialog();
        _loadData();
      } else if (message.notification?.title == "Pesan dari Driver") {
        _showReceivedMessageModal(
            context, message.notification?.body ?? 'Pesan tidak ditemukan');
      } else if (message.notification?.title == "Perjalanan selesai") {
        if (message.data.isNotEmpty) {
          String? orderId = message.data['orderId'];
          String? estimatedCost = message.data['estimatedCost'];
          _showEndJourneyBottomSheet(orderId!, estimatedCost!);
        }
      }
      _loadData();
    });
  }

  Future<Set<Polyline>> _getPolylineStatus(
      LatLng customerOrderLocation, LatLng airportLocation) async {
    Set<Polyline> polylines = {};

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${customerOrderLocation.latitude},${customerOrderLocation.longitude}&destination=${airportLocation.latitude},${airportLocation.longitude}&key=AIzaSyBo8MhxZIYfbX9exFOGhOuz-PnoVRwgvLY";

    // Fetch the directions from current location to the airport
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<LatLng> points = _convertToLatLng(
          _decodePoly(data['routes'][0]['overview_polyline']['points']));
      polylines.add(Polyline(
        polylineId: const PolylineId('polylineToAirport'),
        visible: true,
        points: points,
        color: Colors.blue,
        width: 4,
      ));
    }

    return polylines;
  }

// Decode Polyline points
  List<LatLng> _convertToLatLng(List<dynamic> points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1] / 1E5, points[i] / 1E5));
      }
    }
    return result;
  }

  List<dynamic> _decodePoly(String poly) {
    List<int> bytes = utf8.encode(poly);
    List<dynamic> list = [];
    int index = 0;
    int len = poly.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int byte;
      do {
        byte = bytes[index++] - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        byte = bytes[index++] - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      list.add(lat);
      list.add(lng);
    }

    return list;
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
                    'Berikut harga perjalanan yang harus Anda bayar secara tunai sesuai perhitungan aplikasi. Berikan rating dan ulasan Anda kepada driver jika berkenan :)',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
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
                'Pesan ini dikirimkan oleh Driver dari pesanan taksi Anda.',
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

  void _showUpdatePositionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFF1E282C),
          content: Row(
            children: [
              Lottie.asset(
                'lottie/splash_screen.json',
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Text(
                  "Update posisi driver...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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

  Future<void> addCustomAirportIcon() async {
    final ByteData imageData = await rootBundle.load("images/airport.png");
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: 100,
      targetHeight: 100,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();

    final BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.fromBytes(resizedImageData);
    setState(() {
      markerIconAirport = bitmapDescriptor;
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
    context.read<GetCurrentOrderBloc>().add(LoadGetCurrentOrder());
  }

  Future<void> _refreshData() async {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            BlocBuilder<GetCurrentOrderBloc, GetCurrentOrderState>(
              builder: (context, state) {
                return _buildGetCurrentOrderContent(context, state);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetCurrentOrderContent(
      BuildContext context, GetCurrentOrderState state) {
    if (state is GetCurrentOrderLoading) {
      return const LoadingModalDataBackground();
    } else if (state is GetCurrentOrderLoaded) {
      return _buildLoadedCurrentOrderContent(state);
    } else if (state is GetCurrentOrderFailure) {
      print(state.errorMessage);
      if (state.errorMessage == "Unauthorized") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.toNamed('/onBoarding');
        });
      } else if (state.errorMessage == "no_current_order") {
        return const NoCurrentOrder();
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

  Widget _buildLoadedCurrentOrderContent(GetCurrentOrderLoaded state) {
    final String id = state.model.id;
    final double customerOrderLat = state.model.lat;
    final double customerOrderLong = state.model.long;
    final int status = state.model.status;
    final DriverInfo driver = state.model.driver;

    final double driverLat = driver.lat;
    final double driverLong = driver.long;

    final String estimationDuration = state.model.estimationDuration;
    final String estimationDistance = state.model.estimationDistance;

    final RideInfo ride = state.model.rideInfo;

    final int pickupRadius = ride.pickupRadius;
    final double rideLat = ride.lat;
    final double rideLong = ride.long;

    if (driverLat != 0 && driverLong != 0) {
      initialCameraPosition = CameraPosition(
        target: LatLng(driverLat, driverLong),
        zoom: 15.0,
        bearing: 90,
      );
    } else {
      initialCameraPosition = CameraPosition(
        target: LatLng(customerOrderLat, customerOrderLong),
        zoom: 15.0,
        bearing: 90,
      );
    }

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('orderLocation'),
        position: LatLng(customerOrderLat, customerOrderLong),
        infoWindow: const InfoWindow(
          title: 'Lokasi Penjemputan',
        ),
        icon: markerIconCustomer
      ),
      Marker(
        markerId: const MarkerId('rideLocation'),
        position: LatLng(rideLat, rideLong),
        infoWindow: const InfoWindow(
          title: 'Lokasi Pengantaran',
        ),
        icon: markerIconRideTaxi,
      ),
      Marker(
        markerId: const MarkerId('supadioAirportLocation'),
        position: const LatLng(-0.100105, 109.376221),
        infoWindow: const InfoWindow(
          title: 'Lokasi Bandar Udara Supadio',
        ),
        icon: markerIconAirport,
      ),
    };

    if (driverLat != 0.0 && driverLong != 0.0) {
      markers.add(
        Marker(
          markerId: const MarkerId('driverLocation'),
          position: LatLng(driverLat, driverLong),
          infoWindow: const InfoWindow(
            title: 'Lokasi Driver',
          ),
          icon: markerIconTaxi,
        ),
      );
    }

    return FutureBuilder<String>(
      future: _getLocationName(customerOrderLat, customerOrderLong),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingModalDataBackground();
        } else if (snapshot.hasError) {
          return SomethingError(onNavigate: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    const DasboardTemplate(initialPageIndex: 2),
              ),
            );
          });
        } else {
          String locationName = snapshot.data ?? 'Terjadi kesalahan...';
          locationAddress = locationName;

          final String statusText = _getStatusText(status);

          return Column(
            children: [
              Stack(children: [
                SizedBox(
                  height: 440,
                  child: FutureBuilder<Set<Polyline>>(
                    future: status == 1
                        ? _getPolylineStatus(
                            LatLng(driverLat, driverLong),
                            LatLng(customerOrderLat, customerOrderLong),
                          )
                        : status == 2
                            ? _getPolylineStatus(
                                LatLng(driverLat, driverLong),
                                LatLng(customerOrderLat, customerOrderLong),
                              )
                            : status == 3
                                ? _getPolylineStatus(
                                    LatLng(driverLat, driverLong),
                                    const LatLng(-0.100105, 109.376221),
                                  )
                                : _getPolylineStatus(
                                    LatLng(rideLat, rideLong),
                                    LatLng(customerOrderLat, customerOrderLong),
                                  ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading indicator while waiting for the polylines
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        // Handle any errors that occur during the Future
                        return const Center(
                          child: Text('Error loading route data'),
                        );
                      } else if (snapshot.hasData) {
                        // Display the map with polylines once data is loaded
                        return GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          initialCameraPosition: initialCameraPosition,
                          onMapCreated: (GoogleMapController controller) {},
                          zoomGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          gestureRecognizers: <Factory<
                              OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer()),
                          },
                          rotateGesturesEnabled: true,
                          markers: markers,
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
                          polylines: snapshot.data!,
                        );
                      } else {
                        // Show a fallback UI if there is no data (optional)
                        return const Center(
                          child: Text('No route data available'),
                        );
                      }
                    },
                  ),
                ),
                Center(
                  child: FloatingWidget(
                    verticalSpace: 20,
                    duration: const Duration(
                      seconds: 1,
                    ),
                    reverseDuration: const Duration(seconds: 1),
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xff27374D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'lottie/splash_screen.json',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _getStatusText(status),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informasi Data Pemesanan
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
                                }
                                if (state is SendMessageSuccess) {
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
                                icon: const Icon(Icons.message,
                                    color: Colors.white),
                                onPressed: () {
                                  _showMessageModal(context, id);
                                },
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white),
                              onSelected: (String value) {
                                if (value == 'Detail Driver') {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return _buildDriverDetailSheet(
                                          context, driver, status);
                                    },
                                  );
                                } else if (value == 'Detail Pesanan') {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return _buildOrderDetailSheet(
                                          context, state.model);
                                    },
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return {'Detail Driver', 'Detail Pesanan'}
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

                    // Informasi Lokasi Penjemputan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.place, color: Colors.white),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            locationName,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Informasi Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_rounded, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          statusText,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Estimasi waktu dan jarak
                    if (driverLat != 0 && driverLong != 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (status == 1 || status == 2)
                            const Text(
                              'Estimasi penjemputan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            )
                          else if (status == 3)
                            const Text(
                              'Estimasi ketibaan di bandara',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          const SizedBox(height: 10),
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
                                    const Icon(Icons.timer,
                                        color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      estimationDuration,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.route,
                                        color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      estimationDistance,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 10),

                    // Tombol Batalkan Pesanan
                    BlocListener<CancelOrderBloc, CancelOrderState>(
                      listener: (context, state) {
                        if (state is CancelOrderFailure) {
                          if (state.errorMessage == "Unauthorized") {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Get.toNamed('/onBoarding');
                            });
                          }
                          AnimatedSnackBar.removeAll();
                          AnimatedSnackBar.material(
                            'Data pesanan gagal dibatalkan!',
                            type: AnimatedSnackBarType.error,
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                          _loadData();
                        }
                        if (state is CancelOrderSuccess) {
                          AnimatedSnackBar.removeAll();
                          AnimatedSnackBar.material(
                            'Data pesanan berhasil dibatalkan!',
                            type: AnimatedSnackBarType.success,
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                          _loadData();
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          CustomBottomSheet.displayConfirmationBottomSheet(
                            context,
                            'Konfirmasi Pembatalan Pesanan Taksi #$id',
                            'Apakah Anda yakin ingin membatalkan pesanan taksi ini?',
                            'images/check.png',
                            () {
                              Navigator.pop(context);
                              final cancelOrderRequestModel =
                                  CancelOrderRequestModel(orderId: id);
                              context.read<CancelOrderBloc>().add(
                                    LoadCancelOrderEvent(
                                        request: cancelOrderRequestModel),
                                  );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const ui.Color.fromARGB(255, 185, 8, 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                        child: const Text(
                          'Batalkan Pesanan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<CancelOrderBloc, CancelOrderState>(
                builder: (context, state) {
                  if (state is CancelOrderLoading) {
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
            ],
          );
        }
      },
    );
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
            'Kirim Pesan ke Driver',
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

  Widget _buildDriverDetailSheet(
      BuildContext context, DriverInfo driver, int status) {
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
                'Detail Driver Taksi Bandara',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ClipOval(
                child: Image.network(
                  driver.photo,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Menambahkan average rating dan ikon bintang
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 22),
                const SizedBox(width: 10),
                Text(
                  driver.averageRating.toStringAsFixed(
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
                  driver.name,
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
                const Icon(Icons.card_membership, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  driver.noMembership,
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
                const Icon(Icons.directions_car, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  driver.licensePlate,
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
                  '(+62) ${driver.phoneNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailSheet(
      BuildContext context, GetCurrentOrderResponseModel model) {
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
                    child: Text('Lokasi Penjemputan \n$locationAddress',
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
                      const Icon(Icons.info_rounded,
                          size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Status Pengantaran\n${_getStatusText2(model.rideInfo.rideStatus)}',
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
                  'Jarak Lokasi Pemesanan Anda ke Bandara \n${(model.customerToAirportDistance / 1000).toStringAsFixed(1)} km',
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
                      Flexible(
                        child: Text(
                          'Tarif Per Km\n${model.farePerKm},00',
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
                      const Icon(Icons.money, size: 24, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Estimasi Biaya\n${model.cost},00',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        return 'Menunggu konfirmasi driver';
      case 1:
        return 'Pesanan diterima oleh driver';
      case 2:
        return 'Dalam perjalanan menjemput anda';
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
}
