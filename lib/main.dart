import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Auto-generated file after Firebase setup

// Community Feature Pages
import 'community_page/community_contact.dart';
import 'community_page/locals.dart';
import 'community_page/damini_page.dart';
import 'community_page/nirbhaya_page.dart';
import 'community_page/tejashwini_page.dart';

// Timer Module
import 'screens/timer/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women Safety App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Women Safety App Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _location = "Press button to get location";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _location = "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _location = "Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _location = "Location permissions permanently denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = "Lat: ${position.latitude}, Long: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                _location,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Start Timer", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CommunityHomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Open Community", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getLocation,
            tooltip: 'Get Location',
            child: const Icon(Icons.location_on),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class CommunityHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCircleIcon(context, 'assets/damini.png', Colors.red, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DaminiPage()));
                  }),
                  SizedBox(width: 20),
                  buildCircleIcon(context, 'assets/nirbhaya.png', Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => NirbhayaPage()));
                  }),
                  SizedBox(width: 20),
                  buildCircleIcon(context, 'assets/tejashwini.png', Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TejashwiniPage()));
                  }),
                ],
              ),
            ),
            buildGroupButton(context, "FAMILY", "assets/family.png"),
            SizedBox(height: 20),
            buildGroupButton(context, "FRIENDS", "assets/friends.png"),
            SizedBox(height: 20),
            buildGroupButton(context, "COLLEAGUES", "assets/colleagues.png"),
            SizedBox(height: 20),
            buildLocalsButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildCircleIcon(BuildContext context, String imagePath, Color bgColor, VoidCallback onTap) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: bgColor,
      child: IconButton(
        icon: Image.asset(imagePath, width: 40, height: 40),
        onPressed: onTap,
      ),
    );
  }

  Widget buildGroupButton(BuildContext context, String label, String imagePath) {
    return buildCustomButton(
      context,
      imagePath: imagePath,
      label: label,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => CommunityContact(groupName: label)));
      },
    );
  }

  Widget buildLocalsButton(BuildContext context) {
    return buildCustomButton(
      context,
      imagePath: 'assets/gps.png',
      label: 'LOCALS',
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LocalsPage()));
      },
    );
  }

  Widget buildCustomButton(BuildContext context,
      {required String imagePath,
        required String label,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 130,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
