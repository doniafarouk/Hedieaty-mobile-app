import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/drawer.dart';
import '../giftlist_page.dart';
import '../profilepage.dart';
import '../friendlist.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> friends = [
    {'name': 'Medhat', 'profilePicture': Icons.person, 'events': 1},
    {'name': 'Mary', 'profilePicture': Icons.person, 'events': 0},
    {'name': 'Metwaly', 'profilePicture': Icons.person, 'events': 3},
  ];

  // Navigation to ProfilePage
  void goToProfilepage(BuildContext context) {
    Navigator.of(context).pop(); // Close Drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  // Sign-out logic
  void signOut(BuildContext context) async {
    Navigator.of(context).pop(); // Close Drawer
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed out successfully.')),
    );
    Navigator.of(context).pushReplacementNamed('screens/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hedieaty'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: MyDrawer(
        onProfileTap: () => goToProfilepage(context),
        onSignOutTap: () => signOut(context),
      ),
      body: Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // "Create Your Own Event/List" Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateEventPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your Own Event/List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Friend List
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
                    trailing: friend['events'] > 0
                        ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                            child: Text(
                        '${friend['events']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : null,
                    subtitle: Text(friend['events'] > 0
                        ? "Upcoming Events: ${friend['events']}"
                        : "No Upcoming Events"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GiftListPage(eventName: 'dd',),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Sign Out Button
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade300,
          color: Colors.deepPurple.shade100,
          items: [
        Icon(Icons.home),
        Icon(Icons.favorite),
        Icon(Icons.settings),
      ]),
    );
  }
}

// Dummy page for creating events/lists
class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event/List'),
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Text('Create Event/List Page'),
      ),
    );
  }
}

// Dummy page for friend's profile
class FriendProfilePage extends StatelessWidget {
  final String friendName;

  const FriendProfilePage({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$friendName\'s Profile'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text('Gift lists for $friendName'),
      ),
    );
  }
}
