import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart'; // Main App Home
//import 'screens/login_screen.dart'; // You should create this screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions(); // Ask permissions
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  await Permission.location.request();
  await Permission.sms.request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /*Future<bool> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Women's Safety App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),

      /*home: FutureBuilder<bool>(
        future: _isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            //return snapshot.data == true ? const HomeScreen() : const LoginScreen();
          }
        },
      ),*/
    );
  }
}
