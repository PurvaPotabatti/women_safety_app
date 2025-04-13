import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:women_safety_app/screens/home_screen.dart';

class EmergencyContactsPage extends StatefulWidget {
  final String userId;
  final bool isNewUser;

  const EmergencyContactsPage({
    super.key,
    required this.userId,
    this.isNewUser = false,
  });

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  int contactCount = 0;

  void _addContact({String? name, String? number}) async {
    final contactName = name ?? nameController.text.trim();
    final contactNumber = number ?? numberController.text.trim();

    if (contactName.isEmpty || contactNumber.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('contacts')
        .add({'name': contactName, 'number': contactNumber});

    nameController.clear();
    numberController.clear();
  }

  void _pickContactFromPhone() async {
    if (!await FlutterContacts.requestPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to access contacts')),
      );
      return;
    }

    final Contact? contact = await FlutterContacts.openExternalPick();
    if (contact != null && contact.phones.isNotEmpty) {
      _addContact(
        name: contact.displayName,
        number: contact.phones.first.number,
      );
    }
  }

  void _editContact(String docId, String currentName, String currentNumber) {
    nameController.text = currentName;
    numberController.text = currentNumber;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .collection('contacts')
                  .doc(docId)
                  .update({
                'name': nameController.text.trim(),
                'number': numberController.text.trim(),
              });

              nameController.clear();
              numberController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              nameController.clear();
              numberController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('contacts')
        .doc(docId)
        .delete();
  }

  void _proceedToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(userId: widget.userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('contacts');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Emergency Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _addContact(),
                        icon: const Icon(Icons.add),
                        label: const Text("Add Contact"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _pickContactFromPhone,
                      icon: const Icon(Icons.contacts),
                      label: const Text("From Phone"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            "Saved Contacts",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: contactsRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                // Update contact count for enabling "Proceed" button
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && contactCount != docs.length) {
                    setState(() {
                      contactCount = docs.length;
                    });
                  }
                });

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['name']),
                      subtitle: Text(data['number']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editContact(
                              doc.id,
                              data['name'],
                              data['number'],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteContact(doc.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (widget.isNewUser)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: contactCount >= 3 ? _proceedToHome : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "Proceed to Home",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
