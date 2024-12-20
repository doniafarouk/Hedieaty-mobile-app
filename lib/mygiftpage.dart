import 'package:flutter/material.dart';

class MyGiftsPage extends StatefulWidget {
  final Map<String, dynamic> event; // Receive event data

  MyGiftsPage({required this.event}); // Constructor

  @override
  _MyGiftsPageState createState() => _MyGiftsPageState();
}

class _MyGiftsPageState extends State<MyGiftsPage> {
  List<Map<String, dynamic>> gifts = []; // Maintain gifts for the event
  String _sortBy = 'Name'; // Default sorting by name

  @override
  void initState() {
    super.initState();
    // Initialize the gifts list with the event's gifts (if any)
    gifts = List.from(widget.event['gifts'] ?? []);
  }

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

  void _editGift(int index) {
    TextEditingController giftNameController =
    TextEditingController(text: gifts[index]['name']);
    TextEditingController giftCategoryController =
    TextEditingController(text: gifts[index]['category']);
    TextEditingController giftPriceController =
    TextEditingController(text: gifts[index]['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Gift"),
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
                setState(() {
                  gifts[index]['name'] = giftNameController.text;
                  gifts[index]['category'] = giftCategoryController.text;
                  gifts[index]['price'] =
                      double.tryParse(giftPriceController.text) ?? 0.0;
                });
                Navigator.pop(context);
              },
              child: Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }

  void _deleteGift(int index) {
    setState(() {
      gifts.removeAt(index);
      widget.event['gifts'].removeAt(index); // Remove from event's gifts
    });
  }

  void _togglePledge(int index) {
    setState(() {
      gifts[index]['isPledged'] = !gifts[index]['isPledged']; // Toggle pledge state
    });
  }

  void _sortGifts(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      if (sortBy == 'Name') {
        gifts.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (sortBy == 'Category') {
        gifts.sort((a, b) => a['category'].compareTo(b['category']));
      } else if (sortBy == 'Pledged') {
        gifts.sort((a, b) => a['isPledged'] ? 1 : 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gifts for ${widget.event['eventName']}"),
        backgroundColor: Colors.blueGrey,
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortGifts,
            itemBuilder: (BuildContext context) {
              return ['Name', 'Category', 'Pledged'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text('Sort by $choice'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(gifts[index]['name']),
                  subtitle: Text(
                      "Category: ${gifts[index]['category']}, Price: \$${gifts[index]['price']}"),
                  tileColor: gifts[index]['isPledged']
                      ? Colors.green[100]
                      : Colors.transparent,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editGift(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteGift(index),
                      ),
                      IconButton(
                        icon: Icon(
                          gifts[index]['isPledged']
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: gifts[index]['isPledged']
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () => _togglePledge(index),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GiftDetailsPage(gift: gifts[index]),
                      ),
                    );
                  },
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

class GiftDetailsPage extends StatelessWidget {
  final Map<String, dynamic> gift;

  GiftDetailsPage({required this.gift});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gift['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${gift['name']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Category: ${gift['category']}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Price: \$${gift['price']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              "Pledged: ${gift['isPledged'] ? 'Yes' : 'No'}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
//
// class Gift {
//   final String name;
//   final String category;
//   final double price;
//   String status; // "Available", "Pledged", "Purchased"
//
//   Gift({
//     required this.name,
//     required this.category,
//     required this.price,
//     this.status = "Available",
//   });
// }
//
// class GiftListPage extends StatefulWidget {
//   final String eventName;
//
//   GiftListPage({required this.eventName});
//
//   @override
//   _GiftListPageState createState() => _GiftListPageState();
// }
//
// class _GiftListPageState extends State<GiftListPage> {
//   // Sample list of gifts
//   List<Gift> gifts = [
//     Gift(name: "Toy Car", category: "Toys", price: 15.99),
//     Gift(name: "Book", category: "Education", price: 9.99),
//     Gift(name: "Chocolate Box", category: "Food", price: 12.49),
//   ];
//
//   void updateGiftStatus(Gift gift, String newStatus) {
//     setState(() {
//       gift.status = newStatus; // Update the status
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Gifts for ${widget.eventName}"),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: ListView.builder(
//         itemCount: gifts.length,
//         itemBuilder: (context, index) {
//           final gift = gifts[index];
//
//           // Determine color based on status
//           Color statusColor;
//           switch (gift.status) {
//             case "Pledged":
//               statusColor = Colors.green;
//               break;
//             case "Purchased":
//               statusColor = Colors.red;
//               break;
//             default:
//               statusColor = Colors.grey;
//           }
//
//           return Card(
//             color: statusColor.withOpacity(0.2), // Light background tint
//             child: ListTile(
//               title: Text(gift.name),
//               subtitle: Text("Category: ${gift.category}, Price: \$${gift.price.toStringAsFixed(2)}"),
//               trailing: DropdownButton<String>(
//                 value: gift.status,
//                 items: ["Available", "Pledged", "Purchased"]
//                     .map((status) => DropdownMenuItem(
//                   value: status,
//                   child: Text(status),
//                 ))
//                     .toList(),
//                 onChanged: (newStatus) {
//                   if (newStatus != null) {
//                     updateGiftStatus(gift, newStatus);
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
