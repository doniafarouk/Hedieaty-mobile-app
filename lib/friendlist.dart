import 'package:flutter/material.dart';
import 'eventlist_page.dart';

class FriendProfilePage extends StatefulWidget {
  final String friendName;

  FriendProfilePage({required this.friendName});

  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final List<Map<String, dynamic>> friendEvents = []; // Maintain events here

  void _addFriendEvent(BuildContext context) {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Event for ${widget.friendName}"),
          content: TextField(
            controller: eventController,
            decoration: InputDecoration(hintText: "Enter event name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (eventController.text.isNotEmpty) {
                  setState(() {
                    // Add the new event to the friendEvents list
                    friendEvents.add({'eventName': eventController.text, 'gifts': 0});
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _viewFriendEvents(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventListPage(
          title: "${widget.friendName}'s Events",
          events: friendEvents, // Pass the friendEvents list to EventListPage
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.friendName}'s Profile"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _addFriendEvent(context),
              child: Text("Add Event"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _viewFriendEvents(context),
              child: Text("View Events"),
            ),
          ],
        ),
      ),
    );
  }
}
