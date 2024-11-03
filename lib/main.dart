import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'giftlist_provider.dart';
import 'homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GiftListProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
