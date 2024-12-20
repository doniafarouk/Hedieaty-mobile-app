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
// class GiftListProvider with ChangeNotifier {
//   List<Gift> _gifts = [
//     Gift(name: "Toy Car", category: "Toys", price: 15.99),
//     Gift(name: "Book", category: "Education", price: 9.99),
//     Gift(name: "Chocolate Box", category: "Food", price: 12.49),
//   ];
//
//   List<Gift> get gifts => _gifts;
//
//   void updateGiftStatus(Gift gift, String newStatus) {
//     gift.status = newStatus;
//     notifyListeners(); // Notify widgets listening to this provider.
//   }
// }
