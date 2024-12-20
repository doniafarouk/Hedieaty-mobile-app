// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile/components/drawer.dart';
// import 'package:mobile/model/UserModel.dart';
// import '../MyPledgitGifts.dart';
// import '../eventlist_page.dart';
// import '../giftlist_page.dart';
// import '../model/database.dart';
// import '../profilepage.dart';
// import '../friendEvents.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   int? userId; // To store the userId
//   final TextEditingController textController = TextEditingController();
//
//
//   final List<Map<String, dynamic>> friends = [
//     {'name': 'Medhat', 'profilePicture': Icons.person, 'events': 1},
//     {'name': 'Mary', 'profilePicture': Icons.person, 'events': 0},
//     {'name': 'Metwaly', 'profilePicture': Icons.person, 'events': 3},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserId();
//   }
//
//   // Navigation to ProfilePage
//   void goToProfilepage(BuildContext context) {
//     Navigator.of(context).pop(); // Close Drawer
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfilePage(),
//       ),
//     );
//   }
//
//   // Sign-out logic
//   void signOut(BuildContext context) async {
//     Navigator.of(context).pop(); // Close Drawer
//     await FirebaseAuth.instance.signOut();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Signed out successfully.')),
//     );
//     Navigator.of(context).pushReplacementNamed('screens/login');
//   }
//
//   // Fetch userId from Firebase and DatabaseHelper
//   Future<void> _fetchUserId() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       int? fetchedUserId = await DatabaseHelper().getUserIdByEmail(user.email!);
//       print('Fetched userId from database: $fetchedUserId');
//       if (mounted) {
//         setState(() {
//           userId = fetchedUserId;
//         });
//       }
//     }
//   }
//
//   Widget getSelectedWidget(int index) {
//     if (userId == null) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     switch (index) {
//       case 0:
//         return HomePage(); // Home
//       case 1:
//         return MyPledgedGiftsPage(); // MyPledgedGiftsPage
//       case 2:
//       // return GiftListPage(eventName: 'jj'); // Placeholder
//       case 3:
//         return EventListPage(userId: userId!); // Pass userId dynamically
//       default:
//         return HomePage();
//     }
//   }
//
//
//   // Future getUserId() async{
//   //   final UserModel userModel = UserModel();
//   //   User? user = FirebaseAuth.instance.currentUser;
//   //   user!.displayName;
//   // }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Hedieaty',
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueGrey,
//         actions: [
//           AnimSearchBar(
//             width: 300,
//             textController: textController,
//             onSuffixTap: () {
//               setState(() {
//                 textController.clear();
//               });
//             },
//             onSubmitted: (String value) {
//               // Add search logic if needed
//               print("Search query: $value");
//             },
//           ),
//         ],
//       ),
//       drawer: MyDrawer(
//         onProfileTap: () => goToProfilepage(context),
//         onSignOutTap: () => signOut(context),
//       ),
//       body: _selectedIndex == 0
//           ? Container(
//         color: Colors.grey[300],
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             // Popular Categories Section
//             const Text(
//               "Popular Categories",
//               style: TextStyle(
//                 fontSize: 22,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 80, // Set the height of the horizontal scroll area
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal, // Enables horizontal scrolling
//                 itemCount: 6, // Number of categories
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 16.0), // Space between items
//                     child: Column(
//                       children: [
//                         // Circular icon container
//                         Container(
//                           width: 56,
//                           height: 56,
//                           padding: const EdgeInsets.all(8.0),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                           child: const Icon(
//                             Icons.category,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text("Category ${index + 1}"), // Category label
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//
//             const SizedBox(height: 16),
//
//             // "Create Your Own Event/List" Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EventListPage(userId: userId!),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.add),
//               label: const Text('Create Your Own Event/List'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueGrey,
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 10, horizontal: 20),
//                 textStyle: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Friend List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: friends.length,
//                 itemBuilder: (context, index) {
//                   final friend = friends[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       child: Icon(friend['profilePicture']),
//                     ),
//                     title: Text(friend['name']),
//                     trailing: friend['events'] > 0
//                         ? Container(
//                       padding: const EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         '${friend['events']}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                         : null,
//                     subtitle: Text(friend['events'] > 0
//                         ? "Upcoming Events: ${friend['events']}"
//                         : "No Upcoming Events"),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       )
//           : userId == null
//           ? const Center(child: CircularProgressIndicator())
//           : getSelectedWidget(_selectedIndex),
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.grey.shade300,
//         color: Colors.deepPurple.shade100,
//         buttonBackgroundColor: Colors.blueGrey,
//         index: _selectedIndex,
//         items: const [
//           Icon(Icons.home),
//           Icon(Icons.favorite),
//           Icon(Icons.settings),
//           Icon(Icons.event),
//         ],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
//
//
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_loadingkit/flutter_animated_loadingkit.dart';
import 'package:mobile/components/drawer.dart';
import 'package:mobile/model/UserModel.dart';
import 'package:mobile/screens/setting.dart';
import 'package:path/path.dart';
import '../MyPledgitGifts.dart';
import '../eventlist_page.dart';
import '../giftlist_page.dart';
import '../model/database.dart';
import '../profilepage.dart';
import '../Friends/friendEvents.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoaderVisible = true; // Track loader visibility
  int _selectedIndex = 0;
  int? userId; // To store the userId to local
  // late String friendId;
  List<String> friendsList = []; // To store the list of friend names or IDs
  final TextEditingController textController = TextEditingController();
  bool _isSearchVisible = false;
  List<Map<String, dynamic>> friends = [];

  List<Map<String, dynamic>> categories = [];


  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchFriends();
    _getFriendsList();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoaderVisible = false; // Hide loader after 3 seconds
      });
    });

  }

  Future<void> _getFriendsList() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    // Get the current user's document from Firestore (assuming the user is authenticated)
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid) // Replace with the actual user ID
        .get();

    // Check if the 'friends' field exists and is a list
    if (userDoc.exists) {
      setState(() {
        friendsList = List<String>.from(userDoc['friends'] ?? []);
      });
      print(friendsList);
      print(friends);

    }
  }

  // Fetch userId from Firebase and DatabaseHelper
  Future<void> _fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      int? fetchedUserId = await DatabaseHelper().getUserIdByEmail(user.email!);
      print('Fetched userId from database: $fetchedUserId');
      if (mounted) {
        setState(() {
          userId = fetchedUserId;
        });
      }
    }
  }

  Future<void> _fetchFriends() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final firestore = FirebaseFirestore.instance;
      try {
        // Fetch the current user's document
        DocumentSnapshot userDoc = await firestore.collection('users').doc(currentUser.uid).get();
        List<dynamic> friendIds = userDoc['friends'] ?? [];

        List<Map<String, dynamic>> updatedFriends = [];
        for (String friendId in friendIds) {
          // Get the friend's document
          DocumentSnapshot friendDoc = await firestore.collection('users').doc(friendId).get();

          // Fetch the count of upcoming events for the friend
          QuerySnapshot eventsSnapshot = await firestore.collection('events')
              .where('user', isEqualTo: friendId) // Find events created by the friend
              // .where('date', isGreaterThanOrEqualTo: Timestamp.now()) // Filter for upcoming events
              .get();

          int eventCount = eventsSnapshot.docs.length;
          //
          // String name;
          // if (friendDoc['email'] != null) {
          //   // Regular friend: Use email as name
          //   name = friendDoc['email'];
          // } else {
          //   // Category or other type of user: Use username
          //   name = friendDoc['username'];
          // }

          updatedFriends.add({
            'name': friendDoc['username'] ,
            'profilePicture': Icons.person, // Default icon
            'events': eventCount, // The number of events for this friend
          });
        }

        setState(() {
          friends = updatedFriends; // Update the state with the fetched friends
        });
        print(friends);
        print(friendIds);
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error fetching friends: $e')) ,
        // );
      }
    }
  }



  Future<void> _searchFriendByEmail(String email) async {
    final firestore = FirebaseFirestore.instance;
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return; // Return early if no user is logged in
    }

    try {
      // Search for users by email, excluding the current user
      var userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('email', isNotEqualTo: currentUser.email) // Exclude current user
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var user = userSnapshot.docs.first;
        String friendUid = user.id; // Use Firestore document ID as friend UID

        // Add the friend's details to the friends list
        setState(() {
          friends.add({
            'name': user['username'], // Use the friend's name
            // 'profilePicture': user['profilePicture'] ?? Icons.person, // Fetch profile picture (or default icon)
            'events': 0, // Placeholder for the number of events, can be customized
          });
        });

        // Add the friend's UID to the current user's friends list
        await firestore.collection('users').doc(currentUser.uid).update({
          'friends': FieldValue.arrayUnion([friendUid]), // Use the document ID as the UID
        });

        // Optionally, you can add the current user's UID to the friend's friends list as well
        await firestore.collection('users').doc(friendUid).update({
          'friends': FieldValue.arrayUnion([currentUser.uid]),
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Friend added successfully!')),
        // );
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('No friend found with this email!')),
        // );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    }
  }

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

  // Return the widget for selected index
  Widget getSelectedWidget(int index) {
    if (userId == null) {
      return Center(child: CircularProgressIndicator());
    }

    switch (index) {
      case 0:
        return HomePage(); // Home
      case 1:
        return MyPledgedGiftsPage(userUid: FirebaseAuth.instance.currentUser!.uid ); // MyPledgedGiftsPage
      case 2:
        return SyncUserDataScreen(userId: userId!); // Placeholder
      case 3:
        return EventListPage(userId: userId!); // Pass userId dynamically
      default:
        return HomePage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    const loader = AnimatedLoadingSideWaySurge(
      expandWidth: 70,
      borderColor: Colors.black,
      speed: Duration(milliseconds: 600),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hedieaty',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          if (_isSearchVisible)
            AnimSearchBar(
              width: 300,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              },
              onSubmitted: (String value) {
                _searchFriendByEmail(value);
              },
            ),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: () => goToProfilepage(context),
        onSignOutTap: () => signOut(context),
      ),
      body: _selectedIndex == 0
          ? Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Friends",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80, // Set the height of the horizontal scroll area
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                itemCount: friends.length + 1, // Adding 1 for the "add friend" button
                itemBuilder: (context, index) {
                  if (index == friends.length) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isSearchVisible = !_isSearchVisible;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                            const Text("Add Friend"), // Button label
                          ],
                        ),
                      ),
                    );
                  }

                  // Display the friend's name in the list
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            friends[index]['profilePicture'], // Display profile picture
                            color: Colors.black,
                          ),
                        ),
                        Text(friends[index]['name']), // Display friend's name
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventListPage(userId: userId!),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your Own Event/List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Friend List
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  // String friendUid = friendsList[index];

                  // Ensure eventList is not empty and has the same length as events
                  // if (index >= friendsList.length) {
                  //   return const SizedBox.shrink(); // Skip rendering if the lists don't match
                  // }
                  String friendUid = friendsList.length > index ? friendsList[index] : '';

                  // String friendUid = friendsList[index];

                  return InkWell(
                    onTap: () async {
                      // Navigate to the FriendEventPage with the selected friend's UID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendEventPage(friendUid: friendUid),
                        ),
                      );
                    },

                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(friend['profilePicture']),
                      ),
                      title: Text(friend['name']),
                      subtitle: Text(friend['events'] > 0
                          ? 'Upcoming Events: ${friend['events']}'
                          : 'No Upcoming Events'),
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
                    ),
                  );
                },
              ),
            ),
          if (_isLoaderVisible)
      Center(
        child: AnimatedLoadingSideWaySurge(
          expandWidth: 70,
          borderColor: Colors.black,
          speed: Duration(milliseconds: 600),
        ),
      ), // Add the loader to be displayed here
          ],
        ),
      )
          : getSelectedWidget(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade300,
      // backgroundColor: Colors.transparent,
        color: Colors.blueGrey,
        height: 60,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
          Icon(Icons.event, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

