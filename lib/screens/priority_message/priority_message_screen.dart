import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PriorityMessageScreen extends StatefulWidget {
  const PriorityMessageScreen({super.key});

  @override
  State<PriorityMessageScreen> createState() => _PriorityMessageScreenState();
}

class _PriorityMessageScreenState extends State<PriorityMessageScreen> {
  String _priority = 'low';
  TextEditingController _messageController = TextEditingController();

  List<String> emergencyContacts = [];
  List<String> communityContacts = []; // Will be filled later if needed

  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    try {
      if (userId == null) return;

      // Fetch Emergency Contacts from Firestore
      QuerySnapshot emergencySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .get();

      List<String> emergencyList = emergencySnapshot.docs
          .map((doc) => doc['number'] as String)
          .toList();

      setState(() {
        emergencyContacts = emergencyList;
      });

      // Uncomment this block once community contact logic is implemented
      /*
      QuerySnapshot communitySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('community_contacts')
          .get();

      List<String> communityList = communitySnapshot.docs
          .map((doc) => doc['phone'] as String)
          .toList();

      setState(() {
        communityContacts = communityList;
      });
      */
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }

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
        // Add community contacts to recipient list (if implemented)
        recipients.addAll(communityContacts);
      }

      if (recipients.isEmpty) {
        print("No contacts available to send SMS");
        return;
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
