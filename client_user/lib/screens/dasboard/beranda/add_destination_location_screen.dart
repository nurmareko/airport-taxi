import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:airport_taxi_sharing_user_client/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:qr_flutter/qr_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class AddDestination extends StatefulWidget {
  const AddDestination({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddDestinationState createState() => _AddDestinationState();
}

class _AddDestinationState extends State<AddDestination> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  final _controller = TextEditingController();

  String _selectedAddress = "";

  var uuid = const Uuid();
  String _sessionToken = '1234567890';

  List<dynamic> _placeList = [];

  LatLng? _currentP;
  LatLng? _selectedP;

  Map<PolylineId, Polyline> polylines = {};

  late Future<Map<String, dynamic>> _futureDirection;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerRideLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    addCurrentLocationIcon();
    addDestinationLocationIcon();
    getLocationUpdates().then(
      (_) => getCurrentLocation().then((currentLocation) {
        _currentP = currentLocation;
        if (_selectedP != null) {
          getPolylinePoints(_currentP!, _selectedP!).then((coordinates) {
            generatePolyLineFromPoints(coordinates);
          });
        }
      }),
    );
    _controller.addListener(() {
      _onChanged();
    });
  }

  Future<void> addDestinationLocationIcon() async {
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

  Future<void> addCurrentLocationIcon() async {
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
      markerIcon = bitmapDescriptor;
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
        _currentP =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData currentLocation = await _locationController.getLocation();
    return LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }

  Future<List<LatLng>> getPolylinePoints(
      LatLng start, LatLng? destination) async {
    print("Calling polyline API...");
    if (destination == null) return [];

    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    try {
      // Membuat request untuk mendapatkan polyline
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: GOOGLE_MAPS_API_KEY, // Named argument untuk API key
        request: PolylineRequest(
          // Named argument untuk request
          origin: PointLatLng(start.latitude, start.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        print("Error: ${result.errorMessage}");
      }
    } catch (e) {
      print("Failed to fetch polyline: $e");
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

  _onChanged() {
    // ignore: unnecessary_null_comparison
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    const String placesApiKey = "AIzaSyBo8MhxZIYfbX9exFOGhOuz-PnoVRwgvLY";

    print("hallo ini calling suggestion api");
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$placesApiKey&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print('mydata');
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
          print(_placeList);
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  void _onPlaceSelected(int index) {
    var selectedPlace = _placeList[index];
    var placeId = selectedPlace["place_id"];
    var getLocationName = selectedPlace['description'];

    _getPlaceDetails(placeId).then((latLng) {
      setState(() {
        _selectedP = latLng;
        _selectedAddress = getLocationName;
        if (_currentP != null && _selectedP != null) {
          getPolylinePoints(_currentP!, _selectedP!).then((coordinates) {
            generatePolyLineFromPoints(coordinates);
          });
          _futureDirection = getDirection();
        }
      });
      Navigator.of(context).pop();
      _controller.clear();
      _placeList.clear();
    });
  }

  Future<LatLng> _getPlaceDetails(String placeId) async {
    try {
      print("hallo ini calling getPlaceDetail api");
      const String placesDetailsBaseUrl =
          'https://maps.googleapis.com/maps/api/place/details/json';
      String request =
          '$placesDetailsBaseUrl?place_id=$placeId&key=AIzaSyBo8MhxZIYfbX9exFOGhOuz-PnoVRwgvLY';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        var location = data['result']['geometry']['location'];
        var latitude = location['lat'];
        var longitude = location['lng'];
        return LatLng(latitude, longitude);
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      print(e);
      return const LatLng(0, 0);
    }
  }

  Future<Map<String, dynamic>> getDirection() async {
    String apiKey = 'AIzaSyBo8MhxZIYfbX9exFOGhOuz-PnoVRwgvLY';

    print("hallo ini calling direction api");
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentP!.latitude},${_currentP!.longitude}&destination=${_selectedP!.latitude},${_selectedP!.longitude}&mode=driving&key=$apiKey');

    final response = await http.get(url);

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

  void _showQRCodeDialog() {
    if (_selectedP != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                const Color(0xFF121B22), // Warna latar belakang gelap
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'QR Code Posisi Lokasi Tujuan Anda',
              style: TextStyle(color: Colors.white), // Warna teks putih
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: '${_selectedP!.latitude},${_selectedP!.longitude}',
                  version: QrVersions.auto,
                  size: 200.0,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Berikan ini kepada driver untuk \ndipindai',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style:
                      TextStyle(color: Colors.white), // Warna teks tombol putih
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121B22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          'Tandai Lokasi Tujuan',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Anda dapat menandai lokasi tujuan Anda,\nkemudian kode QR akan dihasilkan dan berikan \nkepada driver untuk dipindai.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E282C),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              backgroundColor:
                                                  const Color(0xFF1E282C),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: _controller,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: "Cari lokasi",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white54),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white54),
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _placeList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            title: Text(
                                                              _placeList[index][
                                                                  "description"],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onTap: () {
                                                              _onPlaceSelected(
                                                                  index);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        _selectedAddress.isEmpty
                                            ? "Pilih lokasi"
                                            : _selectedAddress,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_selectedAddress.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          _selectedAddress = "";
                                          _selectedP = null;
                                          polylines.clear();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
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
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _mapController.complete(controller);
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: _currentP!,
                                    zoom: 14.0,
                                  ),
                                  polylines: Set<Polyline>.of(polylines.values),
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  scrollGesturesEnabled: true,
                                  zoomGesturesEnabled: true,
                                  gestureRecognizers: <Factory<
                                      OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                                  rotateGesturesEnabled: true,
                                  markers: Set<Marker>.of(_currentP != null
                                      ? [
                                          Marker(
                                            markerId: const MarkerId(
                                                "current position"),
                                            position: _currentP!,
                                            icon: markerIcon,
                                            infoWindow: const InfoWindow(
                                              title: 'Lokasi Anda',
                                            ),
                                          ),
                                          if (_selectedP != null)
                                            Marker(
                                              markerId: const MarkerId(
                                                  "selected position"),
                                              position: _selectedP!,
                                              icon: markerRideLocationIcon,
                                              infoWindow: const InfoWindow(
                                                title: 'Lokasi Pengantaran',
                                              ),
                                              draggable:
                                                  true, // Membuat marker dapat dipindah
                                              onDragEnd: (newPosition) async {
                                                _controller
                                                    .clear(); // Clear controller (misalnya untuk peta atau inputan)
                                                setState(() {
                                                  _selectedP =
                                                      newPosition; // Update posisi marker setelah di-drag
                                                });

                                                // Mengambil nama lokasi berdasarkan latitude dan longitude setelah drag
                                                List<Placemark> placemarks =
                                                    await placemarkFromCoordinates(
                                                  newPosition.latitude,
                                                  newPosition.longitude,
                                                );
                                                if (placemarks.isNotEmpty) {
                                                  String locationName = "${placemarks[0].name}, ${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}, ${placemarks[0].country}";

                                                  // Mengupdate _selectedAddress setelah mendapatkan nama lokasi
                                                  setState(() {
                                                    _selectedAddress =
                                                        locationName; // Menyimpan nama lokasi
                                                  });
                                                }

                                                // Menyusun dan menggambar polyline berdasarkan posisi lama (_currentP) dan posisi baru (_selectedP)
                                                getPolylinePoints(
                                                        _currentP!, _selectedP!)
                                                    .then((coordinates) {
                                                  generatePolyLineFromPoints(
                                                      coordinates); // Fungsi untuk menggambar polyline
                                                });

                                                // Mendapatkan arah setelah marker di-drag
                                                _futureDirection =
                                                    getDirection();
                                              },
                                            ),
                                        ]
                                      : []),
                                )
                              else
                                const Center(
                                    child: CircularProgressIndicator()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      if (_currentP != null && _selectedP != null)
                        FutureBuilder<Map<String, dynamic>>(
                          future: _futureDirection,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
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
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      if (_selectedP != null)
                                        SizedBox(
                                          width: double.infinity, // Lebar penuh
                                          child: ElevatedButton(
                                            onPressed: _showQRCodeDialog,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(255, 33,
                                                      156, 144), // Warna tombol
                                              foregroundColor: Colors
                                                  .white, // Warna teks tombol
                                            ),
                                            child:
                                                const Text('Generate QR Code'),
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
