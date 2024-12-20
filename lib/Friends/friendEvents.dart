// //
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class FriendEventPage extends StatefulWidget {
// //   final String friendUid;
// //
// //   FriendEventPage({required this.friendUid});
// //
// //   @override
// //   _FriendEventPageState createState() => _FriendEventPageState();
// // }
// //
// // class _FriendEventPageState extends State<FriendEventPage> {
// //   List<Map<String, dynamic>> events = [];
// //   List<String> giftsList = []; // To store the list of friend names or IDs
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getFriendEvents();
// //     _getGiftList();
// //   }
// //
// //   // Fetch events for the friend based on friendUid
// //   Future<void> _getFriendEvents() async {
// //     try {
// //       // Assuming the events are stored in Firestore under a collection named 'events'
// //       final eventSnapshot = await FirebaseFirestore.instance
// //           .collection('events') // Change this to the correct collection name
// //           .where('user', isEqualTo: widget.friendUid) // Filter events for the specific friend
// //           .get();
// //
// //       List<Map<String, dynamic>> fetchedEvents = [];
// //
// //       for (var doc in eventSnapshot.docs) {
// //         fetchedEvents.add(doc.data());
// //       }
// //
// //       setState(() {
// //         events = fetchedEvents; // Update the state with the fetched events
// //       });
// //     } catch (e) {
// //       print('Error fetching events: $e');
// //     }
// //   }
// //
// //   Future<void> _getGiftList() async {
// //     User? currentUser = FirebaseAuth.instance.currentUser;
// //     // Get the current user's document from Firestore (assuming the user is authenticated)
// //     final userDoc = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(currentUser?.uid) // Replace with the actual user ID
// //         .get();
// //
// //     if (userDoc.exists) {
// //       setState(() {
// //         giftsList = List<String>.from(userDoc['eventId'] ?? []);
// //       });
// //
// //     }
// //   }
// //
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Friend's Events"),
// //         backgroundColor: Colors.blueGrey,
// //         centerTitle: true,
// //         elevation: 5.0,
// //       ),
// //       body: events.isEmpty
// //           ? const Center(
// //         child: Text(
// //           "No events yet. The friend hasn't added any events.",
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
// //         ),
// //       )
// //           :ListView.builder(
// //         padding: const EdgeInsets.all(8),
// //         itemCount: events.length,
// //         itemBuilder: (context, index) {
// //           final event = events[index];
// //
// //           return InkWell(
// //             onTap: () async {
// //               // Navigate to the FriendEventPage with the selected friend's UID
// //               // Navigator.push(
// //               //   context,
// //               //   MaterialPageRoute(
// //               //     builder: (context) => FriendEventPage(friendUid: friendUid),
// //               //   ),
// //               // );
// //             },
// //             child: Card(
// //               elevation: 4,
// //               margin: const EdgeInsets.symmetric(vertical: 8),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
// //               child: ListTile(
// //                 contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //                 leading: CircleAvatar(
// //                   backgroundColor: Colors.blueGrey,
// //                   child: Text(
// //                     event['name'][0], // Assuming 'name' is a field in your event data
// //                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 title: Text(
// //                   event['name'], // Assuming 'name' is a field in your event data
// //                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //                 subtitle: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const SizedBox(height: 4),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.date_range, size: 16, color: Colors.blueGrey),
// //                         const SizedBox(width: 4),
// //                         Text(event['date'].split('.')[0]), // Assuming 'date' is a field in your event data
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
// //                         const SizedBox(width: 4),
// //                         Text(event['location']), // Assuming 'location' is a field in your event data
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.description, size: 16, color: Colors.blueGrey),
// //                         const SizedBox(width: 4),
// //                         Expanded(child: Text(event['description'])), // Assuming 'description' is a field in your event data
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'friendGift.dart';
//
// class FriendEventPage extends StatefulWidget {
//   final String friendUid;
//
//   FriendEventPage({required this.friendUid});
//
//   @override
//   _FriendEventPageState createState() => _FriendEventPageState();
// }
//
// class _FriendEventPageState extends State<FriendEventPage> {
//   List<Map<String, dynamic>> events = [];
//   List<String> eventList = []; // To store the list of event UIDs
//
//   @override
//   void initState() {
//     super.initState();
//     _getFriendEvents();
//     _getGiftList();
//   }
//
//   // Fetch events for the friend based on friendUid
//   Future<void> _getFriendEvents() async {
//     try {
//       // Fetch events from Firestore for the specific friend
//       final eventSnapshot = await FirebaseFirestore.instance
//           .collection('events')
//           .where('user', isEqualTo: widget.friendUid) // Filter events for the specific friend
//           .get();
//
//       List<Map<String, dynamic>> fetchedEvents = [];
//
//       for (var doc in eventSnapshot.docs) {
//         fetchedEvents.add(doc.data());
//       }
//
//       setState(() {
//         //all of events data
//         events = fetchedEvents; // Update the state with the fetched events
//       });
//       print(widget.friendUid);
//
//
//     } catch (e) {
//       print('Error fetching events: $e');
//     }
//   }
//
//   // Fetch the gift list associated with the current user
//   Future<void> _getGiftList() async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//
//     if (currentUser == null) {
//       print("No user is authenticated.");
//       return;
//     }
//
//     try {
//       // Fetch all documents from the gift collection where the user ID matches
//       final giftSnapshot = await FirebaseFirestore.instance
//           .collection('gifts') // Changed collection name to 'gifts'
//           .where('user', isEqualTo: widget.friendUid)
//           .get();
//
//       List<String> fetchedEventList = giftSnapshot.docs
//           .map((doc) {
//         var eventUid = doc.data()['eventUid']?.toString();
//         print("eventUid for doc: $eventUid"); // Log each eventUid
//         return eventUid ?? '';
//
//       })
//           .where((eventUid) => eventUid.isNotEmpty)
//           .toList();
//       setState(() {
//         eventList = fetchedEventList;
//
//       });
//       // final eventSnapshot = await FirebaseFirestore.instance
//       //     .collection('events')
//       //     .doc('QJeE5am3mInN7mv3aAH6')
//       //     .get();
//       // print("Event data: ${eventSnapshot.data()}");
//
//       print("Friend UID: ${widget.friendUid}");
//       print("Fetched events: $events");
//       print("Fetched event UIDs: $eventList");
//
//
//     } catch (e) {
//       print("Error fetching gift list: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Friend's Events"),
//         backgroundColor: Colors.blueGrey,
//         centerTitle: true,
//         elevation: 5.0,
//       ),
//       body: events.isEmpty
//           ? const Center(
//         child: Text(
//           "No events yet. The friend hasn't added any events.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       )
//           : ListView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           final event = events[index];
//           // Ensure eventList is not empty and has the same length as events
//           // if (index >= eventList.length) {
//           //   return const SizedBox.shrink(); // Skip rendering if the lists don't match
//           // }
//           String eventUid = eventList.length > index ? eventList[index] : '';
//           // String eventUid = eventList[index];
//           print('eventuis:  ${eventUid}');
//
//           return InkWell(
//             onTap: () async {
//               // Navigate to the FriendGiftPage with the selected eventUid
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FriendGiftPage(eventId: eventUid),
//                 ),
//               );
//             },
//             child: Card(
//               elevation: 4,
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//               child: ListTile(
//                 contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.blueGrey,
//                   child: Text(
//                     event['name']?[0] ?? 'N', // Default to 'N' if name is null
//                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 title: Text(
//                   event['name'] ?? 'No Name', // Provide a default value if name is missing
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(Icons.date_range, size: 16, color: Colors.blueGrey),
//                         const SizedBox(width: 4),
//                         Text(event['date']?.split('.')[0] ?? 'No Date'), // Handle missing date
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
//                         const SizedBox(width: 4),
//                         Text(event['location'] ?? 'No Location'), // Handle missing location
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.description, size: 16, color: Colors.blueGrey),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(event['description'] ?? 'No Description'), // Handle missing description
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'friendGift.dart';

class FriendEventPage extends StatefulWidget {
  final String friendUid;

  FriendEventPage({required this.friendUid});

  @override
  _FriendEventPageState createState() => _FriendEventPageState();
}

class _FriendEventPageState extends State<FriendEventPage> {
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _getFriendEvents();
  }

  // Fetch events for the friend based on friendUid
  Future<void> _getFriendEvents() async {
    try {
      // Fetch events from Firestore for the specific friend
      final eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('user', isEqualTo: widget.friendUid) // Filter events for the specific friend
          .get();

      List<Map<String, dynamic>> fetchedEvents = [];

      for (var doc in eventSnapshot.docs) {
        Map<String, dynamic> eventData = doc.data();
        String eventUid = doc.id; // Fetch the event UID from the document ID
        eventData['eventUid'] = eventUid; // Add eventUid to event data
        fetchedEvents.add(eventData);
      }

      setState(() {
        events = fetchedEvents; // Update the state with the fetched events
      });

      print("Fetched events with eventUid: $events");

    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend's Events"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        elevation: 5.0,
      ),
      body: events.isEmpty
          ? const Center(
        child: Text(
          "No events yet. The friend hasn't added any events.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          String eventUid = event['eventUid'] ?? '';

          print('eventUid: $eventUid');

          return InkWell(
            onTap: () async {
              // Navigate to the FriendGiftPage with the selected eventUid
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendGiftPage(eventId: eventUid),
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    event['name']?[0] ?? 'N', // Default to 'N' if name is null
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  event['name'] ?? 'No Name', // Provide a default value if name is missing
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 16, color: Colors.blueGrey),
                        const SizedBox(width: 4),
                        Text(event['date']?.split('.')[0] ?? 'No Date'), // Handle missing date
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
                        const SizedBox(width: 4),
                        Text(event['location'] ?? 'No Location'), // Handle missing location
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.description, size: 16, color: Colors.blueGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(event['description'] ?? 'No Description'), // Handle missing description
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
