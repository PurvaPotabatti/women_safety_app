import 'package:flutter/material.dart';
import 'timer/home_screen.dart'; // Adjusted based on your structure

class TimerLauncher extends StatelessWidget {
  const TimerLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start Timer")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          child: const Text("Start Timer", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
