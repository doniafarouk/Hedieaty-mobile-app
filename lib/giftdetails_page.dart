// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'giftlist_provider.dart';
//
// class GiftDetailsPage extends StatefulWidget {
//   @override
//   _GiftDetailsPageState createState() => _GiftDetailsPageState();
// }
//
// class _GiftDetailsPageState extends State<GiftDetailsPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _name = '';
//   String _category = '';
//   double _price = 0.0;
//
//   void _addGift(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       final newGift = Gift(name: _name, category: _category, price: _price);
//       Provider.of<GiftListProvider>(context, listen: false).addGift(newGift);
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add Gift")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onChanged: (value) => _name = value,
//                 validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Category'),
//                 onChanged: (value) => _category = value,
//                 validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => _price = double.tryParse(value) ?? 0.0,
//                 validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _addGift(context),
//                 child: Text('Add Gift'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
