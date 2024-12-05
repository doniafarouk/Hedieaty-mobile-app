import 'package:flutter/material.dart';

class Gift {
  final String name;
  final String category;
  final double price;
  String status; // "Available", "Pledged", "Purchased"

  Gift({
    required this.name,
    required this.category,
    required this.price,
    this.status = "Available",
  });
}

class GiftListPage extends StatefulWidget {
  final String eventName;

  GiftListPage({required this.eventName});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  // Sample list of gifts
  List<Gift> gifts = [
    Gift(name: "Toy Car", category: "Toys", price: 15.99),
    Gift(name: "Book", category: "Education", price: 9.99),
    Gift(name: "Chocolate Box", category: "Food", price: 12.49),
  ];

  void updateGiftStatus(Gift gift, String newStatus) {
    setState(() {
      gift.status = newStatus; // Update the status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gifts for ${widget.eventName}"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];

          // Determine color based on status
          Color statusColor;
          switch (gift.status) {
            case "Pledged":
              statusColor = Colors.green;
              break;
            case "Purchased":
              statusColor = Colors.red;
              break;
            default:
              statusColor = Colors.grey;
          }

          return Card(
            color: statusColor.withOpacity(0.2), // Light background tint
            child: ListTile(
              title: Text(gift.name),
              subtitle: Text("Category: ${gift.category}, Price: \$${gift.price.toStringAsFixed(2)}"),
              trailing: DropdownButton<String>(
                value: gift.status,
                items: ["Available", "Pledged", "Purchased"]
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    updateGiftStatus(gift, newStatus);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
