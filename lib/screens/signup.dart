import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/auth/authService.dart';

import '../model/database.dart';
import 'homepage.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final FirebaseAuthService _authService = FirebaseAuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode(); // FocusNode for email TextField
  final FocusNode _passwordFocusNode = FocusNode(); // FocusNode for password TextField
  final FocusNode _confirmPasswordFocusNode = FocusNode(); // FocusNode for confirm password TextField

  @override
  void dispose() {
    // Dispose controllers and focus nodes to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // void signup() async {
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //   String confirmPassword = _confirmPasswordController.text;
  //
  //   User? user = await _authService.signUpWithEmailAndPassword(email, password);
  //
  //   if (user != null) {
  //     print("User is successfully created");
  //     Navigator.pushNamed(context, '/home'); // Use named routes for navigation
  //   } else {
  //     print("Some error happened"); // Improve error handling (see below)
  //     // Show a SnackBar or Dialog to inform the user about the error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Signup failed. Please try again.')),
  //     );
  //   }
  // }




  Future<void> signup() async {
    if (passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = FirebaseAuth.instance.currentUser;
        // print('print enter display');
        // if (user != null) {
        //   await user.updateDisplayName(_emailController.text.trim());
        // }
        // await user!.reload();
        FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set({
          'username': _emailController.text.split('@')[0],//initial name in email
          'email': _emailController.text.trim(),
        });
        print('print enter local');

        // Save user to SQLite
        // final userData = {
        //   'name': _emailController.text.split('@')[0], // Extract username from email
        //   'email': _emailController.text.trim(),       // Trim email input
        // };
        // // Insert the user into the 'users' table using DatabaseHelper
        // await DatabaseHelper().insertUser(userData);
        // print("printed local");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!')),
        );

        await DatabaseHelper().insertUser({
          'name': _emailController.text.split('@')[0],
          'email': _emailController.text.trim(),
          // 'userId': user.uid, // Store the Firebase user ID in SQLite??
        });
        // int? userId = await DatabaseHelper().getUserIdByEmail(_emailController.text.trim());

        print('print outer local');


        // Show success message or navigate to another page
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Account created successfully!')),
        // );
        // Show success message or navigate to another page

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created successfully!')),
          );

          Future.delayed(Duration(seconds: 5), () {
            // Navigate to another page after showing the snackbar
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
          });
        }

      } on FirebaseAuthException catch (e) {
        print(e.message);
        // Show error message
        String errorMessage = '';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is invalid.';
        } else {
          errorMessage = 'An unexpected error occurred. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      // Show password mismatch error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
    }
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() == _confirmPasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  Icons.card_giftcard,
                  size: 100,
                  color: Colors.blueGrey[600],
                ),

                // Welcome Text
                const SizedBox(height: 20),
                const Text(
                  'Welcome To Hediety',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'Your personalized gift list manager',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Register below',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 40),

                // Email Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next, // Moves to the next field on Enter
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Password Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    textInputAction: TextInputAction.next, // Moves to confirm password field
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Confirm Password Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    textInputAction: TextInputAction.done, // Closes keyboard on Enter
                  ),
                ),

                const SizedBox(height: 30),

                // Sign Up Button
                ElevatedButton(
                  onPressed: signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[600],
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already a member?',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: const Text(
                        ' Log In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
