// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
// import 'secret.dart';
// import 'notification_screen.dart'; // Import notification panel
// import 'package:url_launcher/url_launcher.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   double _latitude = 0.0;
//   double _longitude = 0.0;
//   Timer? _timer;
//   int _timeLeft = 0;
//   bool _isTimerRunning = false;
//   bool _isPaused = false;
//   bool _notifiedForExtension = false;
//
//   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//   List<Map<String, String>> _notifications = [];
//
//   TextEditingController _hoursController = TextEditingController();
//   TextEditingController _minutesController = TextEditingController();
//   TextEditingController _secondsController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//     _getCurrentLocation();
//   }
//
//   void _initializeNotifications() {
//     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initSettings = InitializationSettings(android: androidSettings);
//     _notificationsPlugin.initialize(initSettings);
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _latitude = position.latitude;
//         _longitude = position.longitude;
//       });
//
//       _fetchLocationDetails();
//     } catch (e) {
//       print("Error fetching location: $e");
//     }
//   }
//
//   Future<void> _fetchLocationDetails() async {
//     final String apiKey = Secrets.locationIqApiKey;
//     try {
//       final response = await http.get(
//         Uri.parse('https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$_latitude&lon=$_longitude&format=json'),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print("Location: ${data['display_name']}");
//       } else {
//         throw Exception('Failed to fetch location details');
//       }
//     } catch (e) {
//       print("Error fetching location details: $e");
//     }
//   }
//
//   void _startTimer() {
//     int hours = int.tryParse(_hoursController.text) ?? 0;
//     int minutes = int.tryParse(_minutesController.text) ?? 0;
//     int seconds = int.tryParse(_secondsController.text) ?? 0;
//
//     _timeLeft = (hours * 3600) + (minutes * 60) + seconds;
//     _notifiedForExtension = false;
//
//     if (_timeLeft > 0) {
//       _isTimerRunning = true;
//       _isPaused = false;
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (_timeLeft > 0 && !_isPaused) {
//           setState(() {
//             _timeLeft--;
//           });
//
//           if (_timeLeft == 600 && !_notifiedForExtension) {
//             _sendNotification("Time Alert", "Only 10 minutes left! Extend your timer if needed.");
//             _notifiedForExtension = true;
//           }
//         } else if (_timeLeft == 0) {
//           _sendSOSAlert();
//           _stopTimer();
//         }
//       });
//     }
//   }
//
//   void _pauseResumeTimer() {
//     setState(() {
//       _isPaused = !_isPaused;
//     });
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//     setState(() {
//       _isTimerRunning = false;
//       _isPaused = false;
//       _timeLeft = 0;
//     });
//   }
//   void extendTimer() {
//     setState(() {
//       _timeLeft += 600; // Extends timer by 10 minutes
//     });
//   }
//
//   void _sendSOSAlert() {
//     String googleMapsLink = "https://www.google.com/maps?q=$_latitude,$_longitude";
//     String message = "User is in danger! Tap to view location:\n$googleMapsLink";
//
//     _sendNotification("🚨 SOS Alert", message);
//
//     setState(() {
//       _notifications.insert(0, {"title": "🚨 SOS Alert", "message": message});
//     });
//
//     print("🚨 SOS Triggered! Location: $_latitude, $_longitude 🚨");
//   }
//
//
//
//
//
//   Future<void> _sendNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
//     await _notificationsPlugin.show(0, title, body, notificationDetails);
//
//     // 🔥 Store to Firestore
//     await FirebaseFirestore.instance.collection('notifications').add({
//       'title': title,
//       'body': body,
//       'timestamp': Timestamp.now(),
//     });
//   }
//
//   String _formatTime(int totalSeconds) {
//     int hours = totalSeconds ~/ 3600;
//     int minutes = (totalSeconds % 3600) ~/ 60;
//     int seconds = totalSeconds % 60;
//     return "$hours h : $minutes m : $seconds s";
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Women Safety App"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationScreen(notifications: _notifications)),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Text("Location: $_latitude, $_longitude", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 10),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _hoursController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: "Hours"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: _minutesController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: "Minutes"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: _secondsController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: "Seconds"),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             if (_isTimerRunning)
//               Text("Time Left: ${_formatTime(_timeLeft)}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//
//             const SizedBox(height: 10),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: _isTimerRunning ? null : _startTimer,
//                   child: const Text("Start Timer"),
//                 ),
//                 const SizedBox(width: 9),
//                 ElevatedButton(
//                   onPressed: _isTimerRunning ? _pauseResumeTimer : null,
//                   child: Text(_isPaused ? "Resume" : "Pause"),
//                 ),
//                 const SizedBox(width: 9),
//                 ElevatedButton(
//                   onPressed: _isTimerRunning ? _stopTimer : null,
//                   child: const Text("Cancel Timer"),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//             // Add this GestureDetector for clickable Google Maps link
//             GestureDetector(
//               onTap: () {
//                 String googleMapsLink = "https://www.google.com/maps?q=$_latitude,$_longitude";
//                 Uri googleMapsUri = Uri.parse(googleMapsLink);
//                 launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
//               },
//               child: Text(
//                 "Open Google Maps",
//                 style: TextStyle(
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _sendSOSAlert,
//               child: const Text("Trigger SOS"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'secret.dart';
import 'notification_screen.dart'; // Import notification panel
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety_app/services/sos_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _latitude = 0.0;
  double _longitude = 0.0;
  Timer? _timer;
  int _timeLeft = 0;
  bool _isTimerRunning = false;
  bool _isPaused = false;
  bool _notifiedForExtension = false;

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  List<Map<String, String>> _notifications = [];

  TextEditingController _hoursController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _getCurrentLocation();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      _fetchLocationDetails();
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> _fetchLocationDetails() async {
    final String apiKey = Secrets.locationIqApiKey;
    try {
      final response = await http.get(
        Uri.parse('https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$_latitude&lon=$_longitude&format=json'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Location: ${data['display_name']}");
      } else {
        throw Exception('Failed to fetch location details');
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }

  void _startTimer() {
    int hours = int.tryParse(_hoursController.text) ?? 0;
    int minutes = int.tryParse(_minutesController.text) ?? 0;
    int seconds = int.tryParse(_secondsController.text) ?? 0;

    _timeLeft = (hours * 3600) + (minutes * 60) + seconds;
    _notifiedForExtension = false;

    if (_timeLeft > 0) {
      _isTimerRunning = true;
      _isPaused = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0 && !_isPaused) {
          setState(() {
            _timeLeft--;
          });

          if (_timeLeft == 600 && !_notifiedForExtension) {
            _sendNotification("Time Alert", "Only 10 minutes left! Extend your timer if needed.");
            _notifiedForExtension = true;
          }
        } else if (_timeLeft == 0) {
          _sendSOSAlert();
          _stopTimer();
        }
      });
    }
  }

  void _pauseResumeTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isPaused = false;
      _timeLeft = 0;
    });
  }
  void extendTimer() {
    setState(() {
      _timeLeft += 600; // Extends timer by 10 minutes
    });
  }

  void _sendSOSAlert() async {
    await sendSOSAlert();

    _sendNotification("🚨 SOS Alert", "SOS has been triggered and sent successfully.");

    setState(() {
      _notifications.insert(0, {
        "title": "🚨 SOS Alert",
        "message": "SOS has been triggered and sent successfully."
      });
    });
  }






  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return "$hours h : $minutes m : $seconds s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Women Safety App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen(notifications: _notifications)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Location: $_latitude, $_longitude", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Hours"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Minutes"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _secondsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Seconds"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_isTimerRunning)
              Text("Time Left: ${_formatTime(_timeLeft)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isTimerRunning ? null : _startTimer,
                  child: const Text("Start Timer"),
                ),
                const SizedBox(width: 9),
                ElevatedButton(
                  onPressed: _isTimerRunning ? _pauseResumeTimer : null,
                  child: Text(_isPaused ? "Resume" : "Pause"),
                ),
                const SizedBox(width: 9),
                ElevatedButton(
                  onPressed: _isTimerRunning ? _stopTimer : null,
                  child: const Text("Cancel Timer"),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Add this GestureDetector for clickable Google Maps link
            GestureDetector(
              onTap: () {
                String googleMapsLink = "https://www.google.com/maps?q=$_latitude,$_longitude";
                Uri googleMapsUri = Uri.parse(googleMapsLink);
                launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
              },
              child: Text(
                "Open Google Maps",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _sendSOSAlert,
              child: const Text("Trigger SOS"),
            ),
          ],
        ),
      ),
    );
  }
}
