import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:women_safety_app/screens/contacts/emergency_contacts.dart';
import 'package:women_safety_app/screens/home_screen.dart';

class ExistingUserLoginPage extends StatefulWidget {
  const ExistingUserLoginPage({super.key});

  @override
  State<ExistingUserLoginPage> createState() => _ExistingUserLoginPageState();
}

class _ExistingUserLoginPageState extends State<ExistingUserLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final userId = userCredential.user!.uid;

      final contactsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .get();

      final hasMinimumContacts = contactsSnapshot.docs.length >= 3;

      if (hasMinimumContacts) {
        // ✅ Go to HomeScreen directly
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(userId: userId),
          ),
        );
      } else {
        // 🚨 Redirect to EmergencyContactsPage with isNewUser: false
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmergencyContactsPage(
              userId: userId,
              isNewUser: false,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Existing User Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          children: [
            const Text('Welcome Back!', style: TextStyle(fontSize: 24)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
