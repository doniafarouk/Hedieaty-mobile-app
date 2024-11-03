import 'package:flutter/material.dart';
import 'giftlist_page.dart';

class EventListPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> events;

  EventListPage({required this.title, required this.events});

  void _addGift(BuildContext context, int eventIndex) {
    TextEditingController giftNameController = TextEditingController();
    TextEditingController giftCategoryController = TextEditingController();
    TextEditingController giftPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Gift"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: giftNameController,
                decoration: InputDecoration(hintText: "Enter gift name"),
              ),
              TextField(
                controller: giftCategoryController,
                decoration: InputDecoration(hintText: "Enter gift category"),
              ),
              TextField(
                controller: giftPriceController,
                decoration: InputDecoration(hintText: "Enter gift price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (giftNameController.text.isNotEmpty &&
                    giftCategoryController.text.isNotEmpty &&
                    giftPriceController.text.isNotEmpty) {
                  Navigator.pop(context);
                  // Increment gift count logic can go here
                }
              },
              child: Text("Add"),
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
        title: Text(title),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event['eventName']),
            subtitle: Text("Gifts: ${event['gifts']}"),
            onTap: () {
              // Navigate to gift list page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiftListPage(eventName: event['eventName']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addGift(context, 0),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
