import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/signup.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool showLoginPage = true;
  //opposite to what it is actually is
  void toggleScreens(){
    setState(() {
      showLoginPage =!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(showRegisterPage: toggleScreens);
    }else {
      return SignupPage(showLoginPage: toggleScreens);
    }
  }
}
