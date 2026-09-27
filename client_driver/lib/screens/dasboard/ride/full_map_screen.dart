import 'dart:async';
import 'dart:ui' as ui;

import 'package:airport_taxi_sharing_driver_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FullMap extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng? destinationLocation;
  final Map<PolylineId, Polyline> polylines;

  const FullMap({
    super.key,
    required this.currentLocation,
    this.destinationLocation,
    required this.polylines,
  });

  @override
  _FullMapState createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Location _locationController = Location();
  LatLng? _currentLocation;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerRideLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomRideLocationIcon();
    addCustomIcon();
    super.initState();
    _currentLocation = widget.currentLocation;
    getLocationUpdates();
  }

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

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      setState(() {
        _currentLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121B22),
        title: const Text('Full Screen Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    const DasboardTemplate(initialPageIndex: 1),
              ),
            );
          },
        ),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14.0,
              ),
              polylines: Set<Polyline>.of(widget.polylines.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(_currentLocation != null
                  ? [
                      Marker(
                        markerId: const MarkerId("current position"),
                        position: _currentLocation!,
                        icon: markerIcon,
                      ),
                      if (widget.destinationLocation != null)
                        Marker(
                          markerId: const MarkerId("destination position"),
                          position: widget.destinationLocation!,
                          icon: markerRideLocationIcon
                        ),
                    ]
                  : []),
            ),
    );
  }
}
