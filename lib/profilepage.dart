import 'package:flutter/material.dart';
import 'mygiftpage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, dynamic>> events = [];

  void _addEvent(BuildContext context) {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Event"),
          content: TextField(
            controller: eventController,
            decoration: InputDecoration(hintText: "Enter event name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (eventController.text.isNotEmpty) {
                  setState(() {
                    // Add the new event to the events list
                    events.add({'eventName': eventController.text, 'gifts': []});
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

  void _navigateToGiftsPage(BuildContext context, Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyGiftsPage(event: event),
      ),
    ).then((_) {
      // Update the state after returning from MyGiftsPage
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index]['eventName']),
                  subtitle: Text('Gifts: ${events[index]['gifts'].length}'),
                  onTap: () => _navigateToGiftsPage(context, events[index]), // Navigate on tap
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _addEvent(context),
              child: Text("Add Event"),
            ),
          ),
        ],
      ),
    );
  }
}
