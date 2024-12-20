import 'package:flutter/material.dart';

class FriendGiftDetailsPage extends StatelessWidget {
  final Map<String, dynamic> gift;

  FriendGiftDetailsPage({required this.gift});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gift['name'] ?? 'Gift Details'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gift Name: ${gift['name']}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${gift['category'] ?? 'No Category'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Description: ${gift['description'] ?? 'No Description'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: ${gift['price']?.toString() ?? 'No Price'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for pledge or purchase status here
              },
              child: const Text("Pledge/Purchase"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
