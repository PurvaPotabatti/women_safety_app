import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety_app/screens/timer/timer_screen.dart' as timer_screen;
import 'package:women_safety_app/screens/priority_message/priority_message_screen.dart';
import 'package:women_safety_app/screens/community_page/community_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> emergencyContacts = [
    '9225831363',
    '9022302137',
    '7020117583',
    '8788113755'
    // Add more contacts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Women's Safety App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildNavButton(
                    context, "Emergency Contacts", Icons.contact_phone, Colors.blue),
                _buildNavButton(
                    context, "Community", Icons.people, Colors.green),
                _buildNavButton(
                    context, "Timer", Icons.timer, Colors.orange),
                _buildNavButton(
                    context, "Safety Tips", Icons.security, Colors.purple),
                _buildNavButton(context, "Priority Messaging",
                    Icons.priority_high, Colors.red),
              ],
            ),
          ),
          SizedBox(height: 30),
          FloatingActionButton.extended(
            onPressed: () async {
              await _sendSOS();
            },
            label: Text(
              "SOS ALERT",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            icon: Icon(Icons.sos, size: 30, color: Colors.white),
            backgroundColor: Colors.red,
            elevation: 10,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavButton(
      BuildContext context, String title, IconData icon, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.all(15),
      ),
      onPressed: () {
        if (title == "Timer") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const timer_screen.HomeScreen(),
            ),
          );
        }
        else if (title == "Priority Messaging") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PriorityMessageScreen(),
            ),
          );
        }
        else if (title == "Community") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CommunityHomeScreen(),
            ),
          );
        }
        else if (title == "Safety Tips") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CommunityHomeScreen(),
            ),
          );
        }
        else {
          // You can handle other tabs here if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title page not implemented yet')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Future<void> _sendSOS() async {
    // Request location permission
    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        // Get current location
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        String googleMapsUrl =
            "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

        // Prepare SOS message
        String message =
            "🚨 I'm in danger! Please help. My location: $googleMapsUrl";

        // Combine recipients into a single string separated by commas
        String recipients = emergencyContacts.join(',');

        // Encode message and recipients for the SMS URI
        String uri =
            'sms:$recipients?body=${Uri.encodeComponent(message)}';

        // Launch the SMS app
        if (await canLaunch(uri)) {
          await launch(uri);
        } else {
          print("Could not launch SMS app");
        }
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      print("Location permission not granted");
    }
  }
}
