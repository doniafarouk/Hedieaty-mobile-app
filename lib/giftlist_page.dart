import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'giftlist_provider.dart';

class GiftListPage extends StatelessWidget {
  final String eventName;

  GiftListPage({required this.eventName});

  @override
  Widget build(BuildContext context) {
    final giftListProvider = Provider.of<GiftListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gifts for $eventName"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: giftListProvider.gifts.length,
        itemBuilder: (context, index) {
          final gift = giftListProvider.gifts[index];
          return ListTile(
            title: Text(gift.name),
            subtitle: Text("Category: ${gift.category}, Price: \$${gift.price.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: Icon(gift.isPledged ? Icons.check_circle : Icons.check_circle_outline),
              color: gift.isPledged ? Colors.green : Colors.grey,
              onPressed: () {
                giftListProvider.pledgeGift(gift);
              },
            ),
          );
        },
      ),
    );
  }
}
