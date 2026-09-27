import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class FullMap extends StatefulWidget {
  final double customerLatitude;
  final double customerLongitude;
  final List<Tuple3<maps.LatLng, double, String>> ridePoints;

  const FullMap({
    super.key,
    required this.customerLatitude,
    required this.customerLongitude,
    required this.ridePoints,
  });

  @override
  _FullMapState createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  BitmapDescriptor markerIconCustomer = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconTaxi = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    addCustomCustomerIcon();
    addCustomTaxiIcon();
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

  @override
  Widget build(BuildContext context) {
    // Membuat marker untuk lokasi customer.
    final customerLocationMarker = maps.Marker(
      markerId: const maps.MarkerId('customerLocation'),
      position: maps.LatLng(widget.customerLatitude, widget.customerLongitude),
      icon: markerIconCustomer,
      infoWindow: const maps.InfoWindow(
        title: 'Lokasi Anda',
      ),
    );

    // Menambahkan marker lokasi customer ke dalam list ridePoints markers.
    final allMarkers = widget.ridePoints
        .map((tuple) => maps.Marker(
              markerId: maps.MarkerId(
                  tuple.item3), // Menggunakan rideId sebagai markerId
              position: tuple.item1,
              icon: markerIconTaxi,
              infoWindow: maps.InfoWindow(
                title: 'Lokasi Pengantaran Taxi #${tuple.item3}',
              ),
            ))
        .toSet();

    // Menambahkan customerLocationMarker ke set markers.
    allMarkers.add(customerLocationMarker);

    // Menambahkan lingkaran untuk setiap titik pengantaran dengan radiusnya.
    final circles = widget.ridePoints.map((tuple) {
      return maps.Circle(
        circleId: maps.CircleId(tuple.item1.toString()),
        center: tuple.item1,
        radius: tuple.item2,
        fillColor: Colors.blue.withValues(alpha: 0.1),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121B22),
        title: const Text('Full Screen Map'),
      ),
      body: maps.GoogleMap(
        initialCameraPosition: maps.CameraPosition(
          target:
              maps.LatLng(widget.customerLatitude, widget.customerLongitude),
          zoom: 14.0,
        ),
        markers: allMarkers,
        circles: Set.from(circles),
      ),
    );
  }
}
