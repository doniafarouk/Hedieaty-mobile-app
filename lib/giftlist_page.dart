
import 'package:flutter/material.dart';
import 'giftdetails_page.dart';
import 'model/database.dart';

class GiftListPage extends StatefulWidget {
  final int eventId; // The ID of the event to show the gifts for

  GiftListPage({required this.eventId});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  late DatabaseHelper _databaseHelper;
  List<Gift> _gifts = [];
  String _sortColumn = 'name'; // Default sort by name
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadGifts();
  }

  // Fetch gifts from the database for the given eventId
  Future<void> _loadGifts() async {
    await _databaseHelper.checkAndCreateTables();
    final List<Gift> gifts = await _databaseHelper.getGifts(widget.eventId);
    setState(() {
      _gifts = gifts;
    });
  }

  // Sort gifts based on the selected column and order
  void _sortGifts(String column) {
    setState(() {
      _sortColumn = column;
      _isAscending = !_isAscending;
      _gifts.sort((a, b) {
        int result = 0;
        if (column == 'name') {
          result = a.name.compareTo(b.name);
        } else if (column == 'category') {
          result = a.category.compareTo(b.category);
        } else if (column == 'status') {
          result = a.status.compareTo(b.status);
        }

        return _isAscending ? result : -result;
      });
    });
  }

  // Show a dialog to add a new gift
  void _showAddGiftDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Gift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Gift Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;
                final String category = categoryController.text;
                final double price = double.tryParse(priceController.text) ??
                    0.0;

                if (name.isNotEmpty && category.isNotEmpty) {
                  final newGift = Gift(
                    name: name,
                    description: description,
                    category: category,
                    price: price,
                    status: 'Available',
                    // Default status
                    eventId: widget.eventId,
                  );
                  _databaseHelper.insertGift(newGift).then((id) {
                    _loadGifts();
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to edit an existing gift
  void _showEditGiftDialog(Gift gift) {
    final TextEditingController nameController = TextEditingController(
        text: gift.name);
    final TextEditingController descriptionController = TextEditingController(
        text: gift.description);
    final TextEditingController categoryController = TextEditingController(
        text: gift.category);
    final TextEditingController priceController = TextEditingController(
        text: gift.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Gift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Gift Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String name = nameController.text;
                final String description = descriptionController.text;
                final String category = categoryController.text;
                final double price = double.tryParse(priceController.text) ??
                    0.0;

                if (name.isNotEmpty && category.isNotEmpty) {
                  final updatedGift = Gift(
                    id: gift.id,
                    name: name,
                    description: description,
                    category: category,
                    price: price,
                    status: gift.status,
                    // Keep existing status
                    eventId: widget.eventId,
                  );
                  _databaseHelper.updateGift(
                      updatedGift.id!, updatedGift.toMap()).then((_) {
                    _loadGifts();
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Delete a gift
  void _deleteGift(int giftId) async {
    await _databaseHelper.deleteGift(giftId);
    _loadGifts(); // Reload gifts after deleting
  }

  // Mark gift as pledged
  void _markAsPledged(int giftId) async {
    await _databaseHelper.updateGiftStatus(giftId, 'Pledged');
    _loadGifts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gift List"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        elevation: 5.0,
      ),
      body: _gifts.isEmpty
          ? const Center(
        child: Text(
          "No gifts yet. Add your first gift!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _gifts.length,
        itemBuilder: (context, index) {
          final gift = _gifts[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  gift.name[0],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                gift.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                          Icons.category, size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text(gift.category),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.description,
                          size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text(gift.description),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text("\$${gift.price.toStringAsFixed(2)}"),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit button
                  if (gift.status != 'Pledged')
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => _showEditGiftDialog(gift),
                    ),
                  // Delete buttons
                  if (gift.status != 'Pledged')
                    IconButton(
                      icon:
                      const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteGift(gift.id!),
                    ),
                  // Pledge button (only visible if the gift is not pledged)
                  // if (gift.status != 'Pledged')
                  //   IconButton(
                  //     icon:
                  //     const Icon(Icons.check_circle, color: Colors.green),
                  //     onPressed: () => _markAsPledged(gift.id!),
                  //   ),
                ],
              ),
              tileColor: gift.status == 'Pledged' ? Colors.green[100] : null,
              onTap: () {
                // Navigate to GiftDetailsPage when tapping on the gift
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftDetailsPage(
                      giftId: gift.id,
                      eventId: widget.eventId,
                        refreshGiftList: _loadGifts,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGiftDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add Gift"),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}


