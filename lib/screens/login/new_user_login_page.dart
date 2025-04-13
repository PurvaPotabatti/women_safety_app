import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:women_safety_app/screens/contacts/emergency_contacts.dart';

class NewUserLoginPage extends StatefulWidget {
  const NewUserLoginPage({super.key});

  @override
  State<NewUserLoginPage> createState() => _NewUserLoginPageState();
}

class _NewUserLoginPageState extends State<NewUserLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    print("➡️ Submit pressed");

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || mobile.isEmpty) {
      print("❌ Validation failed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    print("✅ Validation passed");

    setState(() => _isLoading = true);

    try {
      print("🔄 Trying to register user...");

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        final userId = user.uid;

        print('✅Saving to Firestore for userId: $userId');

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'name': name,
          'mobile': mobile,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("✅ Firestore write complete!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmergencyContactsPage(
              userId: userId,
              isNewUser: true,
            ),
          ),
        );
      } else {
        print("❌ User is null after registration");
      }
    } catch (e, st) {
      print("❌ Caught error: $e\n$st");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
      print("🔚 Finished _submit()");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New User Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          children: [
            const Text('Welcome New User!', style: TextStyle(fontSize: 24)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: 'Mobile'),
              keyboardType: TextInputType.phone,
            ),
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
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
