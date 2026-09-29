import 'package:client_driver/blocs/driver/updateLocation/update_location_bloc.dart';
import 'package:client_driver/blocs/orderan/updateLocationOrderan/update_location_orderan_bloc.dart';
import 'package:client_driver/data/models/request/update_location_orderan_request_model.dart';
import 'package:client_driver/data/models/request/update_location_request_model.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._privateConstructor();
  static final LocationService instance = LocationService._privateConstructor();

  Stream<Position>? _positionStream;

  Stream<Position>? get positionStream => _positionStream;

  Future<void> startLocationUpdates(UpdateLocationBloc updateLocationBloc,
      UpdateLocationOrderanBloc updateLocationOrderanBloc) async {
    // Periksa izin lokasi sebelum memulai
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Meminta izin lokasi jika tidak diberikan
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Jika pengguna tetap menolak, hentikan proses
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle jika pengguna menolak izin secara permanen
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // Pastikan layanan lokasi aktif
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Setelah izin diberikan dan layanan aktif, mulai pembaruan lokasi
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // Set akurasi yang diinginkan
      distanceFilter: 100, // Set jarak minimal filter
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);

    _positionStream?.listen((Position position) {
      // Tangani pembaruan lokasi di sini
      print('Current location: $position');

      // Membuat requestModelLocation dengan koordinat baru
      final requestModelLocation = UpdateLocationRequestModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Membuat requestModelLocation dengan koordinat baru
      final requestModelLocationOrderan = UpdateLocationOrderanRequestModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Mengirim event ke UpdateLocationBloc
      updateLocationBloc.add(
        LoadUpdateLocationEvent(request: requestModelLocation),
      );

      // Mengirim event ke UpdateLocationBloc
      updateLocationOrderanBloc.add(
        LoadUpdateLocationOrderanEvent(request: requestModelLocationOrderan),
      );
    });
  }

  Future<void> stopLocationUpdates() async {
    _positionStream?.listen((_) {}).cancel();
    _positionStream = null;
  }
}
