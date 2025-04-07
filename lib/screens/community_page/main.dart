import 'package:flutter/material.dart';
import 'dart:ui';
import 'community_contact.dart';
import 'locals.dart';

// Import Pathak pages
import 'damini_page.dart';
import 'nirbhaya_page.dart';
import 'tejashwini_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women Safety App',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Row with circular Pathak icons
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

            // Main category buttons
            buildFamilyButton(context),
            SizedBox(height: 20),
            buildFriendsButton(context),
            SizedBox(height: 20),
            buildColleaguesButton(context),
            SizedBox(height: 20),
            buildNeighborsButton(context),
          ],
        ),
      ),
    );
  }

  // ⭕ Pathak Icon Widget
  Widget buildCircleIcon(BuildContext context, String imagePath, Color backgroundColor, VoidCallback onTap) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: backgroundColor,
      child: IconButton(
        icon: Image.asset(imagePath, width: 40, height: 40),
        onPressed: onTap,
      ),
    );
  }

  // 🔷 Group Button Widgets
  Widget buildFamilyButton(BuildContext context) {
    return buildCustomButton(
      context,
      imagePath: 'assets/family.png',
      label: 'FAMILY',
      height: 130,
      width: double.infinity,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CommunityContact(groupName: "Family"),
        ));
      },
    );
  }

  Widget buildFriendsButton(BuildContext context) {
    return buildCustomButton(
      context,
      imagePath: 'assets/friends.png',
      label: 'FRIENDS',
      height: 130,
      width: double.infinity,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CommunityContact(groupName: "Friends"),
        ));
      },
    );
  }

  Widget buildColleaguesButton(BuildContext context) {
    return buildCustomButton(
      context,
      imagePath: 'assets/colleagues.png',
      label: 'COLLEAGUES',
      height: 130,
      width: double.infinity,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CommunityContact(groupName: "Colleagues"),
        ));
      },
    );
  }

  Widget buildNeighborsButton(BuildContext context) {
    return buildCustomButton(
      context,
      imagePath: 'assets/gps.png',
      label: 'LOCALS',
      height: 130,
      width: double.infinity,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => LocalsPage(),
        ));
      },
    );
  }

  // 🔶 Reusable Custom Button with blur effect
  Widget buildCustomButton(
      BuildContext context, {
        required String imagePath,
        required String label,
        required double height,
        required double width,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: width,
              height: height,
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
