import 'package:flutter/material.dart';
import 'dart:io';
import '../model/database.dart';

class GiftDetailsPage extends StatefulWidget {
  final int? giftId; // Pass null if it's a new gift
  final int eventId;
  final Function refreshGiftList; // Add this callback to refresh GiftListPage

  GiftDetailsPage({this.giftId, required this.eventId, required this.refreshGiftList});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile;
  String _status = 'Available'; // Default status
  bool _isPledged = false;

  @override
  void initState() {
    super.initState();

    if (widget.giftId != null) {
      _loadGiftDetails(widget.giftId!);
    }
  }

  Future<void> _loadGiftDetails(int giftId) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Gift> gifts = await dbHelper.getGifts(widget.eventId);
    final gift = gifts.firstWhere((gift) => gift.id == giftId);

    setState(() {
      _nameController.text = gift.name;
      _descriptionController.text = gift.description;
      _categoryController.text = gift.category;
      _priceController.text = gift.price.toString();
      _status = gift.status;
      _isPledged = _status == 'Pledged';
    });
  }

  // Disable saving if the gift is pledged
  Future<void> _saveGift() async {
    if (_isPledged) return; // Prevent saving if the gift is pledged

    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      // Show an error if fields are empty
      return;
    }

    // Validate price input
    double? price = double.tryParse(_priceController.text);
    if (price == null) {
      // Show a Snackbar message if the price is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid number for the price.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedGift = Gift(
      id: widget.giftId,
      name: _nameController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      price: price,
      status: _status,
      eventId: widget.eventId,
    );

    DatabaseHelper dbHelper = DatabaseHelper();

    if (widget.giftId == null) {
      // If this is a new gift
      await dbHelper.insertGift(updatedGift);
    } else {
      // If updating an existing gift
      await dbHelper.updateGift(widget.giftId!, updatedGift.toMap());
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gift saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    widget.refreshGiftList(); // Call the callback to refresh the gift list
    Navigator.pop(context); // Close the GiftDetailsPage
  }


  void _showEditGiftDialog(Gift gift) {
    final TextEditingController nameController = TextEditingController(text: gift.name);
    final TextEditingController descriptionController = TextEditingController(text: gift.description);
    final TextEditingController categoryController = TextEditingController(text: gift.category);
    final TextEditingController priceController = TextEditingController(text: gift.price.toString());

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
                final double price = double.tryParse(priceController.text) ?? 0.0;

                if (name.isNotEmpty && category.isNotEmpty) {
                  final updatedGift = Gift(
                    id: gift.id,
                    name: name,
                    description: description,
                    category: category,
                    price: price,
                    status: gift.status,
                    eventId: widget.eventId,
                  );
                  DatabaseHelper dbHelper = DatabaseHelper();
                  dbHelper.updateGift(updatedGift.id!, updatedGift.toMap()).then((_) {
                    widget.refreshGiftList(); // Refresh the list after saving
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.giftId == null ? 'Add Gift' : 'Gift Details'),
        backgroundColor: Colors.blueGrey, // Change AppBar color
        centerTitle: true,
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Gift Name',
              icon: Icons.card_giftcard,
              isPledged: _isPledged,
            ),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              isPledged: _isPledged,
            ),
            _buildTextField(
              controller: _categoryController,
              label: 'Category',
              icon: Icons.category,
              isPledged: _isPledged,
            ),
            _buildPriceField(),
            _buildStatusDisplay(),
            if (!_isPledged)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _saveGift,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(widget.giftId == null ? 'Save New Gift' : 'Save Gift'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool isPledged = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: !isPledged, // Disable if the gift is pledged
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null, // Show icon if provided
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Price',
          prefixIcon: Icon(Icons.monetization_on), // Add the icon here
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        enabled: !_isPledged, // Disable if the gift is pledged
      ),
    );
  }

  Widget _buildStatusDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          'Status: $_status',
          style: TextStyle(
            fontSize: 16,
            color: _isPledged ? Colors.green : Colors.blue,
          ),
        ),
      ),
    );
  }
}


