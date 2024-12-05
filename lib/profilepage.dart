// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'MyPledgitGifts.dart';
// import 'mygiftpage.dart';
// import 'components/text_box.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final List<Map<String, dynamic>> events = [];
//   final currentUser = FirebaseAuth.instance.currentUser!;
//
//   Future<void> editField(String field) async {
//     TextEditingController fieldController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Edit $field"),
//           content: TextField(
//             controller: fieldController,
//             decoration: InputDecoration(hintText: "Enter new $field"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (fieldController.text.isNotEmpty) {
//                   // Simulate saving to a database
//                   setState(() {
//                     // Replace with actual logic if connected to Firestore
//                     // Example: updating a Firestore document
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _addEvent(BuildContext context) {
//     TextEditingController eventController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Add New Event"),
//           content: TextField(
//             controller: eventController,
//             decoration: const InputDecoration(hintText: "Enter event name"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (eventController.text.isNotEmpty) {
//                   setState(() {
//                     events.add({'eventName': eventController.text, 'gifts': []});
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _navigateToGiftsPage(BuildContext context, Map<String, dynamic> event) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MyGiftsPage(event: event),
//       ),
//     ).then((_) {
//       setState(() {});
//     });
//   }
//
//   void _navigateToPledgedGiftsPage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MyPledgedGiftsPage(), // Assuming MyGiftsPage shows pledged gifts
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Profile"),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           const Icon(Icons.person, size: 72),
//           const SizedBox(height: 10),
//           Text(
//             currentUser.email!,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const Divider(thickness: 1, height: 30),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'My Details',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 10),
//                   TextBox(
//                     text: 'ay haga', // Change to the actual user's name
//                     sectionName: 'Username',
//                     onPressed: () => editField('Username'),
//                   ),
//                   const SizedBox(height: 10),
//                   TextBox(
//                     text: 'User Notifications', // Example: Notification setting placeholder
//                     sectionName: 'Notification Settings',
//                     onPressed: () => editField('Notification Settings'),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: events.isEmpty
//                 ? const Center(child: Text("No events added yet."))
//                 : ListView.builder(
//               itemCount: events.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   key: ValueKey(events[index]['eventName']),
//                   title: Text(events[index]['eventName']),
//                   subtitle: Text('Gifts: ${events[index]['gifts'].length}'),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () => _navigateToGiftsPage(context, events[index]),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () => _addEvent(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueGrey,
//               ),
//               child: const Text("Add Event"),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () => _navigateToPledgedGiftsPage(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueGrey,
//               ),
//               child: const Text("My Pledged Gifts"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import 'mygiftpage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String username = "Loading...";
  final List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _getUsername();
  }
    void _navigateToGiftsPage(BuildContext context, Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyGiftsPage(event: event),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  Future<void> _getUsername() async {
    try {
      // Fetch the user's document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'] ?? 'No username found';
        });
      } else {
        setState(() {
          username = "No user data found";
        });
      }
    } catch (e) {
      setState(() {
        username = "Error retrieving username";
      });
      print("Error fetching username: $e");
    }
  }



  Future<void> _editUsername() async {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Username"),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(hintText: "Enter new username"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newUsername = usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  try {
                    // Update Firestore document
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.uid)
                        .update({'username': newUsername});

                    setState(() {
                      username = newUsername;
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    print("Error updating username: $e");
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _addEvent(BuildContext context) {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Event"),
          content: TextField(
            controller: eventController,
            decoration: const InputDecoration(hintText: "Enter event name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (eventController.text.isNotEmpty) {
                  setState(() {
                    events.add({'eventName': eventController.text, 'gifts': []});
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
              child: WidgetCircularAnimator(
                outerColor: Colors.deepPurple.shade400,
                innerColor: Colors.blue,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[200]),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.deepPurple[200],
                    size: 60,
                  ),
                ),
              )),
          const SizedBox(height: 10),
          Text(
            currentUser.email!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1, height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text("Username"),
                    subtitle: Text(username),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _editUsername,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text("No events added yet."))
                : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  key: ValueKey(events[index]['eventName']),
                  title: Text(events[index]['eventName']),
                  subtitle: Text('Gifts: ${events[index]['gifts'].length}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _navigateToGiftsPage(context, events[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _addEvent(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              child: const Text("Add Event"),
            ),
          ),
        ],
      ),
    );
  }
}


