import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/auth/wrapper.dart';
import 'package:provider/provider.dart';
import 'giftlist_provider.dart';
import 'screens/homepage.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => GiftListProvider(),
//       child: MyApp(),
//     ),
//   );
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      home: Wrapper(),
    );
  }
}
