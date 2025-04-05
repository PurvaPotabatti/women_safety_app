import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications;

  const NotificationScreen({super.key, required this.notifications});

  void _openGoogleMaps(String message) {
    // Extract URL from the message
    RegExp regex = RegExp(r'https://www.google.com/maps\?q=[0-9\.,\-]+');
    Match? match = regex.firstMatch(message);

    if (match != null) {
      String googleMapsUrl = match.group(0)!;
      Uri googleMapsUri = Uri.parse(googleMapsUrl);
      launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification History")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]["title"] ?? ""),
            subtitle: Text(notifications[index]["message"] ?? ""),
            onTap: () => _openGoogleMaps(notifications[index]["message"] ?? ""),
          );
        },
      ),
    );
  }
}
