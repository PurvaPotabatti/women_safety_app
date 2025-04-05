import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  static StreamSubscription<Position>? _positionStream;
  static Position? currentPosition;

  // Request location permissions before starting tracking
  static Future<void> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }
  }

  // Start tracking live location
  static void startTracking() async {
    await requestPermission(); // Ensure permissions are granted

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Updates every 10 meters
      ),
    ).listen((Position position) {
      currentPosition = position;
      print("Updated Location: ${position.latitude}, ${position.longitude}");
    });
  }

  // Stop tracking location
  static void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  // Get last known location
  static Future<Position?> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
