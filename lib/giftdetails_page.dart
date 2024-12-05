import 'package:flutter/material.dart';
// Uncomment to enable image picking functionality
// import 'package:image_picker/image_picker.dart';

class GiftsDetailsPage extends StatefulWidget {
  final Map<String, dynamic> event; // Receive event data

  GiftsDetailsPage({required this.event}); // Constructor

  @override
  _GiftsDetailsPage createState() => _GiftsDetailsPage();
}

class _GiftsDetailsPage extends State<GiftsDetailsPage> {
  final List<Map<String, dynamic>> gifts = []; // Maintain gifts for the event
  // Uncomment for image functionality
  // final ImagePicker _picker = ImagePicker();

  late TextEditingController giftNameController;
  late TextEditingController giftDescriptionController;
  late TextEditingController giftCategoryController;
  late TextEditingController giftPriceController;

  @override
  void initState() {
    super.initState();
    giftNameController = TextEditingController();
    giftDescriptionController = TextEditingController();
    giftCategoryController = TextEditingController();
    giftPriceController = TextEditingController();
  }

  @override
  void dispose() {
    giftNameController.dispose();
    giftDescriptionController.dispose();
    giftCategoryController.dispose();
    giftPriceController.dispose();
    super.dispose();
  }

  // Function to pick an image
  // Future<void> _pickImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     return image.path;
  //   }
  // }

  // Function to add a new gift
  void _addGift(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? imagePath; // To store the picked image path
        return AlertDialog(
          title: const Text("Add Gift"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: giftNameController,
                  decoration: const InputDecoration(hintText: "Enter gift name"),
                ),
                TextField(
                  controller: giftDescriptionController,
                  decoration: const InputDecoration(hintText: "Enter gift description"),
                ),
                TextField(
                  controller: giftCategoryController,
                  decoration: const InputDecoration(hintText: "Enter gift category (e.g., electronics, books)"),
                ),
                TextField(
                  controller: giftPriceController,
                  decoration: const InputDecoration(hintText: "Enter gift price"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                // Uncomment for image picker functionality
                // ElevatedButton(
                //   onPressed: () async {
                //     imagePath = await _pickImage();
                //   },
                //   child: const Text("Pick an Image"),
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (giftNameController.text.isNotEmpty &&
                    giftDescriptionController.text.isNotEmpty &&
                    giftCategoryController.text.isNotEmpty &&
                    giftPriceController.text.isNotEmpty) {
                  setState(() {
                    final gift = {
                      'name': giftNameController.text,
                      'description': giftDescriptionController.text,
                      'category': giftCategoryController.text,
                      'price': double.tryParse(giftPriceController.text) ?? 0.0,
                      'isPledged': false,
                      'image': imagePath, // Store the image path
                    };
                    gifts.add(gift);
                    widget.event['gifts'].add(gift);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Function to toggle pledge state
  void _togglePledge(int index) {
    if (!gifts[index]['isPledged']) {
      setState(() {
        gifts[index]['isPledged'] = !gifts[index]['isPledged'];
      });
    }
  }

  // Function to edit the gift details
  void _editGift(int index) {
    if (gifts[index]['isPledged']) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Gift is Pledged"),
            content: const Text("You cannot modify a pledged gift."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } else {
      giftNameController.text = gifts[index]['name'];
      giftDescriptionController.text = gifts[index]['description'];
      giftCategoryController.text = gifts[index]['category'];
      giftPriceController.text = gifts[index]['price'].toString();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Gift"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: giftNameController,
                    decoration: const InputDecoration(hintText: "Enter gift name"),
                  ),
                  TextField(
                    controller: giftDescriptionController,
                    decoration: const InputDecoration(hintText: "Enter gift description"),
                  ),
                  TextField(
                    controller: giftCategoryController,
                    decoration: const InputDecoration(hintText: "Enter gift category"),
                  ),
                  TextField(
                    controller: giftPriceController,
                    decoration: const InputDecoration(hintText: "Enter gift price"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    gifts[index]['name'] = giftNameController.text;
                    gifts[index]['description'] = giftDescriptionController.text;
                    gifts[index]['category'] = giftCategoryController.text;
                    gifts[index]['price'] = double.tryParse(giftPriceController.text) ?? 0.0;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    }
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editGift(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => gifts[index]['isPledged'] ? null : () => setState(() => gifts.removeAt(index)),
                      ),
                      IconButton(
                        icon: Icon(
                          gifts[index]['isPledged'] ? Icons.check_circle : Icons.check_circle_outline,
                          color: gifts[index]['isPledged'] ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => _togglePledge(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _addGift(context),
              child: const Text("Add Gift"),
            ),
          ),
        ],
      ),
    );
  }
}
