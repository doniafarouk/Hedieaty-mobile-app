// import 'database.dart';
//
// class UserModel {
//   static Future<int?> fetchLocalUserId(String email) async {
//     final String sql = '''
//     SELECT id FROM users WHERE email = '$email'
//
//     ''';
//     final DatabaseHelper db = DatabaseHelper(); // Create an instance of MyDatabase
//
//     try {
//       final List<Map<String, dynamic>> result = await db.readData(sql);
//
//       if (result.isNotEmpty) {
//         return result.first['id'] as int; // Return the first 'id' found
//       } else {
//         return null; // No matching user found
//       }
//     } catch (e) {
//       print('Error fetching user ID: $e');
//       return null; // Return null if any error occurs
//     }
//   }
// // //   // Function to get the userId from the local database by email
// // //   final DatabaseHelper _dbHelper = DatabaseHelper();
// // //   Future<int?> getUserIdByEmail(String email) async {
// // //     var db = _dbHelper.database;
// // //     // final db = await database;
// // //     final result = await db.query(
// // //       'users',
// // //       where: 'email = ?',
// // //       whereArgs: [email],
// // //     );
// // //
// // //     if (result.isNotEmpty) {
// // //       return result.first['id'] as int?;
// // //     } else {
// // //       return null; // Return null if no user is found
// // //     }
// // //   }
// // // }