import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendSOSAlert() async {
  try {

     final user = FirebaseAuth.instance.currentUser;

     if(user == null)
       {
         print("User not logged in");
         return;
       }

      final String userId = user.uid;
    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    String message =
        "🚨 I'm in danger! Please help. My location: $googleMapsUrl";

    // Fetch emergency contacts from Firestore
     // Fetch emergency contacts from subcollection
     QuerySnapshot contactSnapshot = await FirebaseFirestore.instance
         .collection('users')
         .doc(userId)
         .collection('contacts')
         .get();

     List<String> contacts = [];

     for (var doc in contactSnapshot.docs) {
       final data = doc.data() as Map<String, dynamic>;
       if (data.containsKey('number')) {
         contacts.add(data['number']);
       }
     }

     if (contacts.isEmpty) {
       print("No contacts to send SOS.");
       return;
     }

     String uri = 'sms:${contacts.join(',')}?body=${Uri.encodeComponent(message)}';

     if (await canLaunch(uri)) {
       await launch(uri);
     } else {
       print("Could not launch SMS app");
     }
  } catch (e) {
    print("Error sending SOS alert: $e");
  }


  // Fetch community contacts from Firestore
    /*DocumentSnapshot communityDoc = await FirebaseFirestore.instance
        .collection('community')
        .doc(userId)
        .get();

    List<String> communityContacts = [];
    if (communityDoc.exists) {
      Map<String, dynamic> data = communityDoc.data() as Map<String, dynamic>;
      communityContacts = List<String>.from(data['numbers'] ?? []);
    }

    List<String> allRecipients = [...contacts, ...communityContacts];*/

}
