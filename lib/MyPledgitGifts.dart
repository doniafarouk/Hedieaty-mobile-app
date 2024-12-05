import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/text_box.dart';  // Assuming you have this component for editing fields

class MyPledgedGiftsPage extends StatefulWidget {
  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> pledgedGifts = []; // List of pledged gifts

  @override
  void initState() {
    super.initState();
    _loadPledgedGifts();
  }

  // Load pledged gifts from Firestore (for example)
  Future<void> _loadPledgedGifts() async {
    FirebaseFirestore.instance
        .collection('pledgedGifts')
        .where('userId', isEqualTo: currentUser.uid)
        .get()
        .then((snapshot) {
      setState(() {
        pledgedGifts = snapshot.docs.map((doc) {
          return {
            'giftName': doc['giftName'],
            'friendName': doc['friendName'],
            'dueDate': doc['dueDate'].toDate(),
            'isPending': doc['isPending'],
            'giftId': doc.id
          };
        }).toList();
      });
    });
  }

  // Edit or remove pledged gift
  Future<void> _modifyPledge(String giftId) async {
    TextEditingController newDueDateController = TextEditingController();
    bool isPending = true;

    // Get the current pledge details for editing
    var pledge = pledgedGifts.firstWhere((gift) => gift['giftId'] == giftId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modify Pledge"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newDueDateController,
                decoration: const InputDecoration(hintText: "Enter new due date"),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Pledge is still pending:"),
                  Switch(
                    value: isPending,
                    onChanged: (value) {
                      setState(() {
                        isPending = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newDueDateController.text.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('pledgedGifts')
                      .doc(giftId)
                      .update({
                    'dueDate': DateTime.parse(newDueDateController.text),
                    'isPending': isPending,
                  }).then((_) {
                    Navigator.pop(context);
                    _loadPledgedGifts(); // Refresh the pledge list
                  });
                }
              },
              child: const Text("Save Changes"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('pledgedGifts')
                    .doc(giftId)
                    .delete()
                    .then((_) {
                  Navigator.pop(context);
                  _loadPledgedGifts(); // Refresh the pledge list
                });
              },
              child: const Text("Remove Pledge"),
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
        title: const Text("My Pledged Gifts"),
        backgroundColor: Colors.blueGrey,
      ),
      body: pledgedGifts.isEmpty
          ? const Center(child: Text("No pledged gifts."))
          : ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          var pledge = pledgedGifts[index];
          return ListTile(
            key: ValueKey(pledge['giftId']),
            title: Text(pledge['giftName']),
            subtitle: Text(
              'Friend: ${pledge['friendName']}\nDue Date: ${pledge['dueDate'].toLocal()}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _modifyPledge(pledge['giftId']);
              },
            ),
          );
        },
      ),
    );
  }
}
