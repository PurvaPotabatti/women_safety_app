import 'dart:math';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

// Class to store latitude and longitude
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}

class LocalsPage extends StatefulWidget {
  @override
  _LocalsPageState createState() => _LocalsPageState();
}

class _LocalsPageState extends State<LocalsPage> {
  LatLng? _currentPosition;
  List<Map<String, dynamic>> _nearbyUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyUsers();
  }

  // ✅ Fetch current location and generate simulated users
  Future<void> _fetchNearbyUsers() async {
    LatLng position = await _getCurrentLocation();
    if (position.latitude != 0.0 && position.longitude != 0.0) {
      List<Map<String, dynamic>> simulatedUsers = _simulateNearbyUsers(position);
      List<Map<String, dynamic>> filteredUsers = _getNearbyUsers(position, simulatedUsers);

      setState(() {
        _currentPosition = position;
        _nearbyUsers = filteredUsers;
      });
    }
  }

  // ✅ Get current location
  Future<LatLng> _getCurrentLocation() async {
    try {
      Location location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return const LatLng(0.0, 0.0);
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return const LatLng(0.0, 0.0);
        }
      }

      final currentLocation = await location.getLocation();
      return LatLng(currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0);
    } catch (e) {
      print("Error getting location: $e");
      return const LatLng(0.0, 0.0);
    }
  }

  // ✅ Generate random nearby users
  List<Map<String, dynamic>> _simulateNearbyUsers(LatLng position) {
    Random random = Random();
    List<Map<String, dynamic>> users = [];

    for (int i = 0; i < 10; i++) {
      double randomLat = position.latitude + (random.nextDouble() - 0.5) * 0.01;
      double randomLng = position.longitude + (random.nextDouble() - 0.5) * 0.01;

      users.add({
        'name': 'User $i',
        'latitude': randomLat,
        'longitude': randomLng,
      });
    }
    return users;
  }

  // ✅ Filter users within 500 meters
  List<Map<String, dynamic>> _getNearbyUsers(LatLng position, List<Map<String, dynamic>> allUsers) {
    return allUsers.where((user) {
      double distance = _calculateDistance(
        position.latitude,
        position.longitude,
        user['latitude'],
        user['longitude'],
      );
      return distance <= 500;
    }).toList();
  }

  // ✅ Haversine formula to calculate distance between coordinates
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  // ✅ UI of the LocalsPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Locals")),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : _nearbyUsers.isEmpty
          ? Center(child: Text("No users found within 500 meters"))
          : ListView.builder(
        itemCount: _nearbyUsers.length,
        itemBuilder: (context, index) {
          var user = _nearbyUsers[index];
          double distance = _calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            user['latitude'],
            user['longitude'],
          );
          return ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text(user['name']),
            subtitle: Text("Distance: ${distance.toStringAsFixed(2)} meters"),
          );
        },
      ),
    );
  }
}
