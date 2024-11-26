import 'package:flutter/foundation.dart';

class Gift {
  String name;
  String category;
  double price;
  bool isPledged;

  Gift({
    required this.name,
    required this.category,
    required this.price,
    this.isPledged = false,
  });
}

class GiftListProvider with ChangeNotifier {
  List<Gift> _gifts = [
    Gift(name: 'Toy Car', category: 'Toys', price: 15.0),
    Gift(name: 'Chocolate Box', category: 'Food', price: 10.0),
  ];

  List<Gift> get gifts => _gifts;

  void addGift(Gift gift) {
    _gifts.add(gift);
    notifyListeners();
  }

  void deleteGift(int index) {
    _gifts.removeAt(index);
    notifyListeners();
  }

  void pledgeGift(Gift gift) {
    final giftIndex = _gifts.indexOf(gift);
    if (giftIndex != -1) {
      _gifts[giftIndex].isPledged = !_gifts[giftIndex].isPledged;
      notifyListeners();
    }
  }
}
