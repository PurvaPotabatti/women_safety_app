import 'package:flutter/material.dart';
import 'new_user_login_page.dart';
import 'existing_user_login_page.dart';

class ChooseLoginScreen extends StatelessWidget {
  const ChooseLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Selection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Login as New User'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewUserLoginPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Login as Existing User'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExistingUserLoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
