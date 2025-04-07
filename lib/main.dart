import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Main Home Screen after app launch
import 'screens/home_screen.dart';

// Community Feature Pages (Commented for now – will move to separate files later)
// import 'community_page/community_contact.dart';
// import 'community_page/locals.dart';
// import 'community_page/damini_page.dart';
// import 'community_page/nirbhaya_page.dart';
// import 'community_page/tejashwini_page.dart';

// Timer Module
// import 'screens/timer/home_screen.dart'; // Timer screen is still accessible via HomeScreen logic

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions(); // Ask for required permissions
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  await Permission.location.request();
  await Permission.sms.request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Women's Safety App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // This is the page launched first
    );
  }
}
