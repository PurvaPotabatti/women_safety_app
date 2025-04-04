import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart'; // For getting the user's current location
import 'secret.dart'; // Import secrets.dart to access the API key

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}
class LocationService {
  static Future<LatLng> getCurrentLocation() async {
    try {
      // Get current device location
      final Location location = Location();
      final currentLocation = await location.getLocation();

      double latitude = currentLocation.latitude ?? 37.7749;  // Default value if null
      double longitude = currentLocation.longitude ?? -122.4194; // Default value if null

      // Fetch the reverse geocoding information (e.g., address details) from LocationIQ
      final String apiKey = Secrets.locationIqApiKey;  // Use the API key from secrets.dart
      final response = await http.get(
          Uri.parse('https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$latitude&lon=$longitude&format=json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Now you have your current location
        latitude = double.parse(data['lat']);
        longitude = double.parse(data['lon']);

        return LatLng(latitude, longitude);
      } else {
        throw Exception('Failed to fetch location');
      }
    } catch (e) {
      print("Error getting location: $e");
      return const LatLng(37.7749, -122.4194); // Default location in case of failure
    }
  }
}
