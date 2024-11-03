import 'package:flutter/material.dart';
import 'profilepage.dart';
import 'friendlist.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> friends = [
    {'name': 'Medhat', 'profilePicture': Icons.person, 'events': 1},
    {'name': 'Mary', 'profilePicture': Icons.person, 'events': 0},
    {'name': 'Metwaly', 'profilePicture': Icons.person, 'events': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hedieaty'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: Icon(Icons.add),
              label: Text('My Profile'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(friend['profilePicture']),
                    ),
                    title: Text(friend['name']),
                    subtitle: Text(friend['events'] > 0
                        ? "Upcoming Events: ${friend['events']}"
                        : "No Upcoming Events"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendProfilePage(friendName: friend['name']),
                        ),
                      );
                    },
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
