import 'package:flutter/material.dart';

class MyGiftsPage extends StatefulWidget {
  final Map<String, dynamic> event; // Receive event data

  MyGiftsPage({required this.event}); // Constructor

  @override
  _MyGiftsPageState createState() => _MyGiftsPageState();
}

class _MyGiftsPageState extends State<MyGiftsPage> {
  final List<Map<String, dynamic>> gifts = []; // Maintain gifts for the event

  void _addGift(BuildContext context) {
    TextEditingController giftNameController = TextEditingController();
    TextEditingController giftCategoryController = TextEditingController();
    TextEditingController giftPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Gift"),
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
                  setState(() {
                    // Add the new gift to the gifts list
                    final gift = {
                      'name': giftNameController.text,
                      'category': giftCategoryController.text,
                      'price': double.tryParse(giftPriceController.text) ?? 0.0,
                      'isPledged': false // Initialize pledge state
                    };
                    gifts.add(gift);
                    widget.event['gifts'].add(gift); // Add to event's gifts
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

  void _togglePledge(int index) {
    setState(() {
      gifts[index]['isPledged'] = !gifts[index]['isPledged']; // Toggle pledge state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Your Gifts for ${widget.event['eventName']}"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(gifts[index]['name']),
                  subtitle: Text("Category: ${gifts[index]['category']}, Price: \$${gifts[index]['price']}"),
                  trailing: Checkbox(
                    value: gifts[index]['isPledged'],
                    onChanged: (value) {
                      _togglePledge(index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _addGift(context),
              child: Text("Add Gift"),
            ),
          ),
        ],
      ),
    );
  }
}
