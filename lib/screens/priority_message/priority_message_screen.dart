import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PriorityMessageScreen extends StatefulWidget {
  const PriorityMessageScreen({super.key});

  @override
  State<PriorityMessageScreen> createState() => _PriorityMessageScreenState();
}

class _PriorityMessageScreenState extends State<PriorityMessageScreen> {
  String _priority = 'low';
  TextEditingController _messageController = TextEditingController();

  final List<String> emergencyContacts = ['9022302137', '9225831363'];
  final List<String> communityContacts = ['7020117583', '8788113755'];

  Future<void> _sendPriorityMessage() async {
    var status = await Permission.location.request();

    if (!status.isGranted) {
      print("Location permission not granted");
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String googleMapsUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      String defaultMessage = "🚨 Priority Alert! My location: $googleMapsUrl";
      String customMessage = _messageController.text.trim();

      String fullMessage =
          "${_priority.toUpperCase()} PRIORITY ALERT:\n${customMessage.isNotEmpty ? customMessage + "\n" : ""}$defaultMessage";

      List<String> recipients = [...emergencyContacts];
      if (_priority == 'high') {
        recipients.addAll(communityContacts);
      }

      String uri =
          'sms:${recipients.join(',')}?body=${Uri.encodeComponent(fullMessage)}';

      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        print("Could not launch SMS app");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Priority Messaging'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Select Priority:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ListTile(
              title: Text("Low Priority (Emergency Contacts Only)"),
              leading: Radio(
                value: 'low',
                groupValue: _priority,
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("High Priority (Emergency + Community)"),
              leading: Radio(
                value: 'high',
                groupValue: _priority,
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: "Optional message...",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _sendPriorityMessage,
              icon: Icon(Icons.send),
              label: Text("Send Message"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
