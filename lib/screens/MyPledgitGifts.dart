// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'components/text_box.dart';  // Assuming you have this component for editing fields
// //
// // class MyPledgedGiftsPage extends StatefulWidget {
// //   @override
// //   _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
// // }
// //
// // class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
// //   final currentUser = FirebaseAuth.instance.currentUser!;
// //   List<Map<String, dynamic>> pledgedGifts = []; // List of pledged gifts
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadPledgedGifts();
// //   }
// //
// //   // Load pledged gifts from Firestore (for example)
// //   Future<void> _loadPledgedGifts() async {
// //     FirebaseFirestore.instance
// //         .collection('pledgedGifts')
// //         .where('userId', isEqualTo: currentUser.uid)
// //         .get()
// //         .then((snapshot) {
// //       setState(() {
// //         pledgedGifts = snapshot.docs.map((doc) {
// //           return {
// //             'giftName': doc['giftName'],
// //             'friendName': doc['friendName'],
// //             'dueDate': doc['dueDate'].toDate(),
// //             'isPending': doc['isPending'],
// //             'giftId': doc.id
// //           };
// //         }).toList();
// //       });
// //     });
// //   }
// //
// //   // Edit or remove pledged gift
// //   Future<void> _modifyPledge(String giftId) async {
// //     TextEditingController newDueDateController = TextEditingController();
// //     bool isPending = true;
// //
// //     // Get the current pledge details for editing
// //     var pledge = pledgedGifts.firstWhere((gift) => gift['giftId'] == giftId);
// //
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text("Modify Pledge"),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               TextField(
// //                 controller: newDueDateController,
// //                 decoration: const InputDecoration(hintText: "Enter new due date"),
// //                 keyboardType: TextInputType.datetime,
// //               ),
// //               const SizedBox(height: 10),
// //               Row(
// //                 children: [
// //                   const Text("Pledge is still pending:"),
// //                   Switch(
// //                     value: isPending,
// //                     onChanged: (value) {
// //                       setState(() {
// //                         isPending = value;
// //                       });
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 if (newDueDateController.text.isNotEmpty) {
// //                   FirebaseFirestore.instance
// //                       .collection('pledgedGifts')
// //                       .doc(giftId)
// //                       .update({
// //                     'dueDate': DateTime.parse(newDueDateController.text),
// //                     'isPending': isPending,
// //                   }).then((_) {
// //                     Navigator.pop(context);
// //                     _loadPledgedGifts(); // Refresh the pledge list
// //                   });
// //                 }
// //               },
// //               child: const Text("Save Changes"),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 FirebaseFirestore.instance
// //                     .collection('pledgedGifts')
// //                     .doc(giftId)
// //                     .delete()
// //                     .then((_) {
// //                   Navigator.pop(context);
// //                   _loadPledgedGifts(); // Refresh the pledge list
// //                 });
// //               },
// //               child: const Text("Remove Pledge"),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("My Pledged Gifts"),
// //         backgroundColor: Colors.blueGrey,
// //       ),
// //       body: pledgedGifts.isEmpty
// //           ? const Center(child: Text("No pledged gifts."))
// //           : ListView.builder(
// //         itemCount: pledgedGifts.length,
// //         itemBuilder: (context, index) {
// //           var pledge = pledgedGifts[index];
// //           return ListTile(
// //             key: ValueKey(pledge['giftId']),
// //             title: Text(pledge['giftName']),
// //             subtitle: Text(
// //               'Friend: ${pledge['friendName']}\nDue Date: ${pledge['dueDate'].toLocal()}',
// //             ),
// //             trailing: IconButton(
// //               icon: const Icon(Icons.edit),
// //               onPressed: () {
// //                 _modifyPledge(pledge['giftId']);
// //               },
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class MyPledgedGiftsPage extends StatelessWidget {
//   final String currentUserId; // Pass the current user ID or email to identify pledges.
//
//   MyPledgedGiftsPage({required this.currentUserId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Pledged Gifts"),
//         backgroundColor: Colors.blueGrey,
//         centerTitle: true,
//         elevation: 5.0,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('gifts')
//             .where('status', isEqualTo: 'pledged')
//             .where('pledgedBy', isEqualTo: currentUserId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 "No pledged gifts found.",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             );
//           }
//
//           final pledgedGifts = snapshot.data!.docs;
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: pledgedGifts.length,
//             itemBuilder: (context, index) {
//               final gift = pledgedGifts[index].data() as Map<String, dynamic>;
//               final giftId = pledgedGifts[index].id;
//
//               return Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0)),
//                 child: ListTile(
//                   contentPadding:
//                   const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.blueGrey,
//                     child: Text(
//                       gift['name'][0], // First letter of the gift's name
//                       style: const TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   title: Text(
//                     gift['name'],
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(Icons.person,
//                               size: 16, color: Colors.blueGrey),
//                           const SizedBox(width: 4),
//                           Text(
//                             gift['friendName'] ?? 'Unknown Friend',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.calendar_today,
//                               size: 16, color: Colors.blueGrey),
//                           const SizedBox(width: 4),
//                           Text(
//                             gift['dueDate'] ?? 'No Due Date',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blueGrey),
//                     onPressed: () {
//                       _modifyPledgeStatus(context, giftId);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // Function to allow the user to modify their pledge status
//   Future<void> _modifyPledgeStatus(BuildContext context, String giftId) async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Modify Pledge",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   await FirebaseFirestore.instance
//                       .collection('gifts')
//                       .doc(giftId)
//                       .update({'status': 'Available', 'pledgedBy': null});
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Cancel Pledge"),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await FirebaseFirestore.instance
//                       .collection('gifts')
//                       .doc(giftId)
//                       .update({'status': 'purchased'});
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Mark as Purchased"),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class MyPledgedGiftsPage extends StatelessWidget {
//   final String userUid; // Change from int to String for user UID
//
//   MyPledgedGiftsPage({required this.userUid}); // Expecting userUid here
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Pledged Gifts'),
//         backgroundColor: Colors.blueGrey,
//         centerTitle: true,
//         elevation: 5.0,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userUid)  // Use userUid to fetch the document
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No pledged gifts.'));
//           }
//
//           final userData = snapshot.data!.data() as Map<String, dynamic>?;
//
//           // Check if userData is null
//           if (userData == null || !userData.containsKey('myPledgedGifts')) {
//             return const Center(child: Text('No pledged gifts.'));
//           }
//
//           final pledgedGifts = List.from(userData['myPledgedGifts'] ?? []);
//
//           if (pledgedGifts.isEmpty) {
//             return const Center(child: Text('No pledged gifts.'));
//           }
//
//           return ListView.builder(
//             itemCount: pledgedGifts.length,
//             itemBuilder: (context, index) {
//               final gift = pledgedGifts[index];
//               return ListTile(
//                 title: Text(gift['giftName'] ?? 'Unknown Gift'),
//                 subtitle: Text('Pledged by: ${gift['friend'] ?? 'Unknown Friend'}'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class MyPledgedGiftsPage extends StatelessWidget {
//   final String userUid;
//
//   MyPledgedGiftsPage({required this.userUid});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Gifts'),
//         backgroundColor: Colors.blueGrey,
//         centerTitle: true,
//         elevation: 5.0,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userUid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No gifts found.'));
//           }
//
//           final userData = snapshot.data!.data() as Map<String, dynamic>?;
//
//           if (userData == null || (!userData.containsKey('myPledgedGifts') && !userData.containsKey('myPurchasedGifts'))) {
//             return const Center(child: Text('No pledged or purchased gifts.'));
//           }
//
//           final pledgedGifts = List.from(userData['myPledgedGifts'] ?? []);
//           final purchasedGifts = List.from(userData['myPurchasedGifts'] ?? []);
//
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Pledged Gifts List
//                 if (pledgedGifts.isNotEmpty) ...[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('Pledged Gifts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: pledgedGifts.length,
//                     itemBuilder: (context, index) {
//                       final gift = pledgedGifts[index];
//                       final friendName = gift['friend'] ?? 'Unknown Friend';
//                       final giftName = gift['giftName'] ?? 'Unknown Gift';
//                       final dueDate = gift['dueDate'] ?? 'Unknown Date';
//
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         elevation: 5,
//                         child: ListTile(
//                           contentPadding: EdgeInsets.all(16),
//                           title: Text(giftName, style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Text('Pledged by: $friendName\nDue: $dueDate'),
//                           trailing: IconButton(
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               _showEditDialog(context, gift['giftId'], giftName, friendName, dueDate);
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//
//                 // Purchased Gifts List
//                 if (purchasedGifts.isNotEmpty) ...[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('Purchased Gifts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: purchasedGifts.length,
//                     itemBuilder: (context, index) {
//                       final gift = purchasedGifts[index];
//                       final friendName = gift['friend'] ?? 'Unknown Friend';
//                       final giftName = gift['giftName'] ?? 'Unknown Gift';
//                       final dueDate = gift['dueDate'] ?? 'Unknown Date';
//
//
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         elevation: 5,
//                         child: ListTile(
//                           contentPadding: EdgeInsets.all(16),
//                           title: Text(giftName, style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Text('Purchased for: $friendName\nDue: $dueDate'),
//                           trailing: IconButton(
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               _showEditDialog(context, gift['giftId'], giftName, friendName, dueDate);
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showEditDialog(BuildContext context, String giftId, String giftName, String friendName, String dueDate) {
//     TextEditingController dueDateController = TextEditingController(text: dueDate);
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Gift Pledge for $giftName'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: dueDateController,
//                 decoration: InputDecoration(labelText: 'Due Date'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 _updateGiftPledge(giftId, dueDateController.text);
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Save Changes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _updateGiftPledge(String giftId, String newDueDate) async {
//     try {
//       await FirebaseFirestore.instance.collection('gifts').doc(giftId).update({
//         'dueDate': newDueDate,
//       });
//
//       // Optionally, show a confirmation message or perform other actions
//     } catch (e) {
//       print('Error updating gift pledge: $e');
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPledgedGiftsPage extends StatelessWidget {
  final String userUid;

  MyPledgedGiftsPage({required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No gifts found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null || !userData.containsKey('myPledgedGifts')) {
            return const Center(child: Text('No pledged gifts.'));
          }

          final pledgedGifts = List.from(userData['myPledgedGifts'] ?? []);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pledged Gifts List
                if (pledgedGifts.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pledged Gifts',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: pledgedGifts.length,
                    itemBuilder: (context, index) {
                      final gift = pledgedGifts[index];
                      final friendName = gift['friend'] ?? 'Unknown Friend';
                      final giftName = gift['giftName'] ?? 'Unknown Gift';
                      final dueDate = gift['dueDate'] ?? 'Unknown Date';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            giftName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Pledged to: $friendName\nDue: $dueDate'),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}



