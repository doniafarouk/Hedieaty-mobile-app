// import 'package:flutter/material.dart';
// import 'giftlist_page.dart';
//
// class EventListPage extends StatelessWidget {
//   final String title;
//   final List<Map<String, dynamic>> events;
//
//   EventListPage({required this.title, required this.events});
//
//   void _addGift(BuildContext context, int eventIndex) {
//     TextEditingController giftNameController = TextEditingController();
//     TextEditingController giftCategoryController = TextEditingController();
//     TextEditingController giftPriceController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Add New Gift"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: giftNameController,
//                 decoration: InputDecoration(hintText: "Enter gift name"),
//               ),
//               TextField(
//                 controller: giftCategoryController,
//                 decoration: InputDecoration(hintText: "Enter gift category"),
//               ),
//               TextField(
//                 controller: giftPriceController,
//                 decoration: InputDecoration(hintText: "Enter gift price"),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (giftNameController.text.isNotEmpty &&
//                     giftCategoryController.text.isNotEmpty &&
//                     giftPriceController.text.isNotEmpty) {
//                   Navigator.pop(context);
//                   // Increment gift count logic can go here
//                 }
//               },
//               child: Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           final event = events[index];
//           return ListTile(
//             title: Text(event['eventName']),
//             subtitle: Text("Gifts: ${event['gifts']}"),
//             onTap: () {
//               // Navigate to gift list page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => GiftListPage(eventName: event['eventName']),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _addGift(context, 0),
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blueGrey,
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// //
// // class EventPage extends StatefulWidget {
// //   @override
// //   _EventPageState createState() => _EventPageState();
// // }
// //
// // class _EventPageState extends State<EventPage> {
// //   final List<Map<String, dynamic>> events = [
// //     {'eventName': 'Birthday Party', 'category': 'Personal', 'status': 'Upcoming'},
// //     {'eventName': 'Team Meeting', 'category': 'Work', 'status': 'Current'},
// //   ];
// //
// //   String sortBy = 'name';
// //
// //   void _addEvent(BuildContext context) {
// //     TextEditingController eventController = TextEditingController();
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text("Add New Event"),
// //           content: TextField(
// //             controller: eventController,
// //             decoration: const InputDecoration(hintText: "Enter event name"),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 if (eventController.text.isNotEmpty) {
// //                   setState(() {
// //                     events.add({
// //                       'eventName': eventController.text,
// //                       'category': 'Uncategorized',
// //                       'status': 'Upcoming'
// //                     });
// //                   });
// //                   Navigator.pop(context);
// //                 }
// //               },
// //               child: const Text("Add"),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   void _editEvent(int index) {
// //     TextEditingController eventController = TextEditingController(
// //       text: events[index]['eventName'],
// //     );
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text("Edit Event"),
// //           content: TextField(
// //             controller: eventController,
// //             decoration: const InputDecoration(hintText: "Enter event name"),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 if (eventController.text.isNotEmpty) {
// //                   setState(() {
// //                     events[index]['eventName'] = eventController.text;
// //                   });
// //                   Navigator.pop(context);
// //                 }
// //               },
// //               child: const Text("Save"),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   void _deleteEvent(int index) {
// //     setState(() {
// //       events.removeAt(index);
// //     });
// //   }
// //
// //   void _sortEvents(String criteria) {
// //     setState(() {
// //       sortBy = criteria;
// //       events.sort((a, b) => a[criteria].compareTo(b[criteria]));
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Manage Events"),
// //         backgroundColor: Colors.blueGrey,
// //         actions: [
// //           PopupMenuButton<String>(
// //             onSelected: _sortEvents,
// //             itemBuilder: (BuildContext context) {
// //               return ['name', 'category', 'status'].map((String choice) {
// //                 return PopupMenuItem<String>(
// //                   value: choice,
// //                   child: Text("Sort by $choice"),
// //                 );
// //               }).toList();
// //             },
// //           ),
// //         ],
// //       ),
// //       body: ListView.builder(
// //         itemCount: events.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(events[index]['eventName']),
// //             subtitle: Text(
// //                 'Category: ${events[index]['category']} | Status: ${events[index]['status']}'),
// //             trailing: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 IconButton(
// //                   icon: const Icon(Icons.edit),
// //                   onPressed: () => _editEvent(index),
// //                 ),
// //                 IconButton(
// //                   icon: const Icon(Icons.delete),
// //                   onPressed: () => _deleteEvent(index),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => _addEvent(context),
// //         backgroundColor: Colors.blueGrey,
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'giftlist_page.dart';
import '../model/database.dart';

class EventListPage extends StatefulWidget {
  final int userId;

  const EventListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Event> events = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final loadedEvents = await _dbHelper.getEvents(widget.userId);
    setState(() {
      events = loadedEvents;
    });
  }

  Future<void> createEvent(String name, String location, String description, String date) async {
    final newEvent = Event(
      userId: widget.userId,
      name: name,
      date: date,
      location: location,
      description: description,
    );
    await _dbHelper.insertEvent(newEvent);
    _loadEvents();
  }

  Future<void> editEvent(Event event, String name, String location, String description, String date) async {
    final updatedEvent = Event(
      id: event.id,
      userId: widget.userId,
      name: name,
      date: date,
      location: location,
      description: description,
    );
    await _dbHelper.updateEvent(updatedEvent);
    _loadEvents();
  }

  void _deleteEvent(int id) async {
    await _dbHelper.deleteEvent(id, widget.userId);
    _loadEvents();
  }

  void _showAddEventDialog() {
    _showEventDialog(isEdit: false);
  }

  void _showEditEventDialog(Event event) {
    _showEventDialog(event: event, isEdit: true);
  }

  void _showEventDialog({Event? event, required bool isEdit}) {
    TextEditingController nameController = TextEditingController(text: event?.name ?? '');
    TextEditingController locationController = TextEditingController(text: event?.location ?? '');
    TextEditingController descriptionController = TextEditingController(text: event?.description ?? '');
    TextEditingController dateController = TextEditingController(
        text: event?.date.split(' ')[0] ?? DateTime.now().toString().split(' ')[0]);

    Future<void> _pickDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          dateController.text = picked.toString().split(' ')[0];
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(
            isEdit ? "Edit Event" : "Add New Event",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, "Event Name", Icons.event),
                const SizedBox(height: 8),
                _buildTextField(locationController, "Location", Icons.location_on),
                const SizedBox(height: 8),
                _buildTextField(descriptionController, "Description", Icons.description),
                const SizedBox(height: 8),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    labelText: "Event Date",
                    prefixIcon: const Icon(Icons.date_range),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (isEdit && event != null) {
                  await editEvent(
                    event,
                    nameController.text,
                    locationController.text,
                    descriptionController.text,
                    dateController.text,
                  );
                } else {
                  await createEvent(
                    nameController.text,
                    locationController.text,
                    descriptionController.text,
                    dateController.text,
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              child: Text(isEdit ? "Save" : "Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("My Events"),
      //   backgroundColor: Colors.blueGrey,
      //   centerTitle: true,
      //   elevation: 5.0,
      // ),
      body: events.isEmpty
          ? const Center(
        child: Text(
          "No events yet. Add your first event!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  event.name[0],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                event.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text(event.date.split('.')[0]),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Text(event.location),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.description, size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(event.description)),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => _showEditEventDialog(event),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteEvent(event.id!),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftListPage( eventId: event.id!),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEventDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add Event"),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}







