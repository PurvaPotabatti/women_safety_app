import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyTipsScreen extends StatefulWidget {
  @override
  _SafetyTipsScreenState createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  List<Map<String, String>> videoList = [
    {
      'title': 'Self Defense Techniques',
      'url': 'https://youtu.be/YGic8TaI44c',
      'id': 'YGic8TaI44c',
    },
    {
      'title': 'Stay Safe on Roads',
      'url': 'https://youtu.be/nTzp0iWbieI',
      'id': 'nTzp0iWbieI',
    },
    {
      'title': 'Safety Gadgets Explained',
      'url': 'https://youtu.be/EQD5S2C6w8E',
      'id': 'EQD5S2C6w8E',
    },
    {
      'title': 'Know Your Rights',
      'url': 'https://youtu.be/Wei_x4hz6iw',
      'id': 'Wei_x4hz6iw',
    },
    {
      'title': 'Quick Tips - Shorts 1',
      'url': 'https://youtube.com/shorts/ULcdMiPBJPE',
      'id': 'ULcdMiPBJPE',
    },
    {
      'title': 'Quick Tips - Shorts 2',
      'url': 'https://youtube.com/shorts/CyBjHSe5FJ4',
      'id': 'CyBjHSe5FJ4',
    },
    {
      'title': 'Emergency Help Tips',
      'url': 'https://youtube.com/shorts/-JEBcNdxSMc',
      'id': '-JEBcNdxSMc',
    },
    {
      'title': 'App Walkthrough',
      'url': 'https://youtu.be/EmKOOZIropE',
      'id': 'EmKOOZIropE',
    },
    {
      'title': 'Pepper Spray Use',
      'url': 'https://youtu.be/KVpxP3ZZtAc',
      'id': 'KVpxP3ZZtAc',
    },
  ];

  String searchText = '';

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredList = videoList.where((video) {
      return video['title']!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Tips'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search videos...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  searchText = val;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                var video = filteredList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          'https://img.youtube.com/vi/${video['id']}/0.jpg',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                  child: Text('Thumbnail not available')),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(video['title']!),
                        trailing: ElevatedButton(
                          onPressed: () => _launchVideo(video['url']!),
                          child: const Text('Watch'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
