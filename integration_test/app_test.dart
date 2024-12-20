// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mobile/auth/authService.dart'; // Correct import for FirebaseAuthService
// import 'package:mobile/screens/login.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mobile/screens/homepage.dart';
// import 'package:provider/provider.dart';
//
// // Mock AuthService class
// class MockAuthService extends Mock implements FirebaseAuthService {}
//
// // Mock User class
// class MockUser extends Mock implements User {}
// // Mock the FirebaseAuth and AuthService classes
//
// class MockFirebaseAuth extends Mock implements FirebaseAuth {}
//
//
// void main() {
//   testWidgets('Login button is disabled when email and password fields are empty', (WidgetTester tester) async {
//     final mockAuthService = MockAuthService();  // Create mockAuthService
//
//     // Ensure that LoginPage is passed the correct mock service and showRegisterPage
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Provider<FirebaseAuthService>.value(
//           value: mockAuthService,  // Provide mockAuthService to the widget tree
//           child: LoginPage(
//             showRegisterPage: () {},  // Empty function as placeholder
//           ),
//         ),
//       ),
//     );
//
//     // Verify that the login button is initially disabled
//     final loginButton = find.byType(ElevatedButton);
//     expect(tester.widget<ElevatedButton>(loginButton).enabled, isFalse);
//   });
//
//   testWidgets('Login button is enabled when both email and password fields are filled', (WidgetTester tester) async {
//     final mockAuthService = MockAuthService();
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Provider<FirebaseAuthService>.value(
//           value: mockAuthService,  // Provide mockAuthService to the widget tree
//           child: LoginPage(showRegisterPage: () {}),
//         ),
//       ),
//     );
//
//     // Enter text into the email and password fields
//     await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
//     await tester.enterText(find.byType(TextField).at(1), 'password123');
//     await tester.pump();
//
//     final loginButton = find.byType(ElevatedButton);
//     expect(tester.widget<ElevatedButton>(loginButton).enabled, isTrue);
//   });
//
//   void main() {
//
//   testWidgets('Successful login calls AuthService and navigates to the home screen', (WidgetTester tester) async {
//   final mockAuthService = MockAuthService();
//   final mockFirebaseAuth = MockFirebaseAuth();
//   final mockUser = MockUser();
//
//
//   // Mock FirebaseAuth instance to use the mockAuthService
//   when(mockFirebaseAuth.signInWithEmailAndPassword(
//   email: 'test@example.com',
//   password: 'password123',
//   )).thenAnswer((_) async => mockUser);
//
//   // Test the widget
//   await tester.pumpWidget(
//   MaterialApp(
//   home: Provider<FirebaseAuthService>.value(
//   value: mockAuthService,  // Provide mockAuthService to the widget tree
//   child: LoginPage(showRegisterPage: () {}),
//   ),
//   routes: {
//   '/home': (context) => Scaffold(appBar: AppBar(title: Text('Home'))),
//   },
//   ),
//   );
//
//   // Enter valid credentials
//   await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
//   await tester.enterText(find.byType(TextField).at(1), 'password123');
//   await tester.pump();
//
//   // Tap the login button
//   await tester.tap(find.byType(ElevatedButton));
//   await tester.pumpAndSettle();
//
//   // Verify that the home screen is displayed after successful login
//   expect(find.text('Home'), findsOneWidget);
//   });
//
//   // Add tests for failed login and Snackbar (if needed).
//   }
//
//
//   testWidgets('Failed login shows an error message', (WidgetTester tester) async {
//     final mockAuthService = MockAuthService();
//
//     // Simulate a failed login
//     when(mockAuthService.signInWithEmailAndPassword(
//       email: 'test@example.com',
//       password: 'wrongpassword',
//     )).thenThrow(FirebaseAuthException(
//       code: 'wrong-password',
//       message: 'The password is incorrect.',
//     ));
//
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Provider<FirebaseAuthService>.value(
//           value: mockAuthService,  // Provide mockAuthService to the widget tree
//           child: LoginPage(showRegisterPage: () {}),
//         ),
//       ),
//     );
//
//     // Enter invalid email and password
//     await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
//     await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');
//     await tester.pump();
//
//     // Tap the login button
//     await tester.tap(find.byType(ElevatedButton));
//     await tester.pumpAndSettle();
//
//     // Verify that the error message is displayed
//     expect(find.text('The password is incorrect.'), findsOneWidget);
//   });
// }
