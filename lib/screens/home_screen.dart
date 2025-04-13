import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:women_safety_app/screens/timer/timer_screen.dart' as timer_screen;
import 'package:women_safety_app/screens/priority_message/priority_message_screen.dart';
import 'package:women_safety_app/screens/contacts/emergency_contacts.dart';
import 'package:women_safety_app/services/sos_service.dart';
import 'package:women_safety_app/screens/community_page/communtiy_screen.dart';
import 'package:women_safety_app/screens/safety_tips/safety_tips.dart';



class HomeScreen extends StatelessWidget {
  final String userId;

  HomeScreen({Key? key, required this.userId}) : super(key: key);

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
                _buildNavButton(context, "Emergency Contacts", Icons.contact_phone, Colors.blue),
                _buildNavButton(context, "Community", Icons.people, Colors.green),
                _buildNavButton(context, "Timer", Icons.timer, Colors.orange),
                _buildNavButton(context, "Safety Tips", Icons.security, Colors.purple),
                _buildNavButton(context, "Priority Messaging", Icons.priority_high, Colors.red),
              ],
            ),
          ),
          SizedBox(height: 30),
          FloatingActionButton.extended(
            onPressed: () async {
              String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
              await sendSOSAlert(); // ✅ Uses the new sos_service.dart
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
        } else if (title == "Priority Messaging") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PriorityMessageScreen(),
            ),
          );
        } else if (title == "Emergency Contacts") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmergencyContactsPage(
                userId: userId,
                isNewUser: false,
              ),
            ),
          );
        } 
        else if (title == "Community") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  CommunityHomeScreen(),
            ),
          );
        }
        else if (title == "Safety Tips") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SafetyTipsScreen(),
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
}
