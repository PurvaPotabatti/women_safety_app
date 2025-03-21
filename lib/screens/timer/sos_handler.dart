import 'package:geolocator/geolocator.dart';
import 'package:women_safety_app/services/location_service.dart';

class SOSHandler {
  static List<String> emergencyContacts = [
    "+911234567890",
    "+919876543210"
  ];

  static Future<void> sendEmergencyAlert() async {
    await LocationService.requestPermission(); // Ensure permissions are granted
    Position? position = await LocationService.getCurrentLocation();

    String locationMessage = position != null
        ? "Emergency! My location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}"
        : "Emergency! Unable to get location.";

    print("SOS ALERT SENT: $locationMessage");

    // TODO: Send this message via API or Firebase if needed
  }
}
