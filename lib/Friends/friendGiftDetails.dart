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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gift name
            Text(
              gift['name'] ?? 'Gift Name',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 8),

            // Category with an icon
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: Colors.blueGrey[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Category: ${gift['category'] ?? 'No Category'}",
                    style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description with an icon and similar styling as Category
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.blueGrey[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Description: ${gift['description'] ?? 'No Description available'}",
                    style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price with an icon
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Price: ${gift['price']?.toString() ?? 'No Price'}",
                  style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display a nice divider to separate content
            Divider(
              color: Colors.grey,
              thickness: 1.5,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
