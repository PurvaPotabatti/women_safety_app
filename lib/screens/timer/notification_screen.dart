import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notification')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications yet."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? '';
              final body = data['body'] ?? '';
              final time = (data['timestamp'] as Timestamp?)?.toDate();
              final lat = data['latitude'];
              final long = data['longitude'];

              // Safe construction of Google Maps URL
              final bool hasValidCoordinates = lat != null && long != null;
              final String? googleMapsUrl = hasValidCoordinates
                  ? "https://www.google.com/maps?q=$lat,$long"
                  : null;

              return ListTile(
                leading: const Icon(Icons.notification_important),
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(body),
                    if (googleMapsUrl != null)
                      GestureDetector(
                        onTap: () {
                          launchUrl(
                            Uri.parse(googleMapsUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: const Text(
                          "View Location on Map",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    if (time != null)
                      Text(
                        "${time.toLocal()}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
