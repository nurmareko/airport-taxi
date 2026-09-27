import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:airport_taxi_sharing_driver_client/blocs/driver/updateLocation/update_location_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/blocs/ride/addRide/add_ride_bloc.dart';
import 'package:airport_taxi_sharing_driver_client/components/confirmation_bottom_sheet.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/add_ride_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_location_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/dasboard_template_screen.dart';
import 'package:airport_taxi_sharing_driver_client/screens/dasboard/ride/full_map_screen.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

import 'package:airport_taxi_sharing_driver_client/const.dart';

import '../../../components/dasboard/loading.dart';

class AddRide extends StatefulWidget {
  const AddRide({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddRideState createState() => _AddRideState();
}

class _AddRideState extends State<AddRide> {
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
  final List<int> _radiusOptions = [1000, 2000, 3000, 4000];
  int _selectedRadius = 1000;

  late Future<Map<String, dynamic>> _futureDirection;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerRideLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    addCustomRideLocationIcon();
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
    print("hallo ini calling polyline api");
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
      width: 8,
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

  Future<void> _scanQRCode() async {
    try {
      final scannedData = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Warna garis scanner
        'Batal', // Tombol batal
        true, // Mode kamera flash
        ScanMode.QR,
      );

      if (scannedData != '-1') {
        // Decode QR untuk mendapatkan latlong
        final latlong =
            scannedData.split(','); // Contoh format: "latitude,longitude"
        final latitude = double.parse(latlong[0].trim());
        final longitude = double.parse(latlong[1].trim());

        // Proses latlong yang diperoleh
        setState(() {
          _selectedP = LatLng(latitude, longitude);

          // Jika posisi saat ini (_currentP) dan posisi yang dipilih (_selectedP) ada, cari polyline
          if (_currentP != null && _selectedP != null) {
            getPolylinePoints(_currentP!, _selectedP!).then((coordinates) {
              generatePolyLineFromPoints(coordinates);
            });
            _futureDirection = getDirection();
          }
        });

        // Mengambil alamat lengkap dari koordinat
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          // Menggunakan format yang diinginkan
          String locationName =
              "${placemarks[0].name}, ${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}, ${placemarks[0].country}";
          setState(() {
            _selectedAddress = locationName; // Menyimpan nama lokasi lengkap
          });
          // Menampilkan alamat lengkap menggunakan SnackBar
          AnimatedSnackBar.material(
            'Lokasi ditemukan: $locationName',
            type: AnimatedSnackBarType.success,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        } else {
          // Jika tidak ada alamat ditemukan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: const Text('Alamat tidak ditemukan')),
          );
        }

        AnimatedSnackBar.material(
          'Data lokasi berhasil didapatkan!',
          type: AnimatedSnackBarType.success,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
      }
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Anda dapat menambahkan pengantaran saat ini. \nSilahkan pilih lokasi dan radius pengantaran!',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _scanQRCode,
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
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
                                                mainAxisSize: MainAxisSize.min,
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
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white54),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          _placeList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Text(
                                                            _placeList[index]
                                                                ["description"],
                                                            style:
                                                                const TextStyle(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Radius pengantaran",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        DropdownButton<int>(
                          value: _selectedRadius,
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedRadius = newValue!;
                            });
                          },
                          items: _radiusOptions.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                "$value meter",
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
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
                            Navigator.push(
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
                                                String locationName =
                                                    "${placemarks[0].name}, ${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}, ${placemarks[0].country}";

                                                // Mengupdate _selectedAddress setelah mendapatkan nama lokasi
                                                setState(() {
                                                  _selectedAddress =
                                                      locationName; // Menyimpan nama lokasi lengkap
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
                                              _futureDirection = getDirection();
                                            },
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
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BlocListener<AddRideBloc, AddRideState>(
                                      listener: (context, state) {
                                        if (state is AddRideFailure) {
                                          AnimatedSnackBar.removeAll();
                                          AnimatedSnackBar.material(
                                            'Data pengantaran gagal ditambahkan!',
                                            type: AnimatedSnackBarType.error,
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.bottom,
                                          ).show(context);
                                        }
                                        if (state is AddRideSuccess) {
                                          AnimatedSnackBar.removeAll();

                                          AnimatedSnackBar.material(
                                            'Data pengantaran berhasil ditambahkan!',
                                            type: AnimatedSnackBarType.success,
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.bottom,
                                          ).show(context);

                                          // Navigasi pertama
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DasboardTemplate(
                                                      initialPageIndex: 1),
                                            ),
                                          );

                                          // Navigasi kedua dengan sedikit delay
                                          Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DasboardTemplate(
                                                        initialPageIndex: 1),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Step 1: Display the confirmation bottom sheet
                                          CustomBottomSheet
                                              .displayConfirmationBottomSheet(
                                            context,
                                            'Konfirmasi Pengantaran',
                                            'Apakah Anda yakin ingin menambah pengantaran ini?',
                                            'images/warning-sign2.png',
                                            () {
                                              // Step 2: Update the driver's position
                                              final updateLocationRequestModel =
                                                  UpdateLocationRequestModel(
                                                latitude: _currentP!.latitude,
                                                longitude: _currentP!.longitude,
                                              );

                                              context
                                                  .read<UpdateLocationBloc>()
                                                  .add(
                                                    LoadUpdateLocationEvent(
                                                        request:
                                                            updateLocationRequestModel),
                                                  );
                                              // Step 3: Add the delivery
                                              final addRideRequestModel =
                                                  AddRideRequestModel(
                                                lat: _selectedP!.latitude,
                                                long: _selectedP!.longitude,
                                                pickupRadius: _selectedRadius,
                                              );
                                              context.read<AddRideBloc>().add(
                                                    LoadAddRideEvent(
                                                        request:
                                                            addRideRequestModel),
                                                  );
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(10),
                                          backgroundColor: const Color.fromARGB(
                                              255, 33, 156, 144),
                                        ),
                                        child: const Text(
                                          'Tambah Pengantaran',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
        BlocBuilder<AddRideBloc, AddRideState>(
          builder: (context, state) {
            if (state is AddRideLoading) {
              return const LoadingModal();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        // BlocBuilder<UpdateLocationBloc, UpdateLocationState>(
        //   builder: (context, state) {
        //     if (state is UpdateLocationLoading) {
        //       return const LoadingModal
        //     } else {
        //       return const SizedBox.shrink();
        //     }
        //   },
        // ),
      ],
    );
  }
}
