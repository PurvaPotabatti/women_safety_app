import 'package:flutter/material.dart';

class TejashwiniPage extends StatefulWidget {
  @override
  _TejashwiniPageState createState() => _TejashwiniPageState();
}

class _TejashwiniPageState extends State<TejashwiniPage> {
  bool isAdmin = false;
  List<String> receivedAlerts = [];

  void _sendAlertToAdmin() {
    if (isAdmin) return;
    setState(() {
      receivedAlerts.add("Emergency Alert at ${DateTime.now()}");
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alert sent to Tejashwini Admin')),
    );
  }

  void _makeThisDeviceAdmin() {
    setState(() {
      isAdmin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tejashwini Pathak')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isAdmin)
              ElevatedButton(
                onPressed: _sendAlertToAdmin,
                child: Text('Send Emergency Alert'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makeThisDeviceAdmin,
              child: Text(isAdmin ? 'You are Admin' : 'Become Admin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdmin ? Colors.green : Colors.orange,
              ),
            ),
            SizedBox(height: 30),
            if (isAdmin)
              Expanded(
                child: ListView.builder(
                  itemCount: receivedAlerts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.warning, color: Colors.red),
                      title: Text(receivedAlerts[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
