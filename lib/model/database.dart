// // import 'package:sqflite/sqflite.dart';
// // import 'package:path/path.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'dart:io';
// //
// // class DatabaseHelper {
// //   static Database? _database;
// //
// //   // Singleton pattern to get a single instance of the database
// //   static Future<Database> get database async {
// //     if (_database != null) return _database!;
// //     _database = await _initDB();
// //     return _database!;
// //   }
// //
// //   // Initialize the database
// //   static Future<Database> _initDB() async {
// //     var directory = await getApplicationDocumentsDirectory();
// //     String path = join(directory.path, 'gift_manager.db');
// //     return await openDatabase(path, version: 1, onCreate: _createDB);
// //   }
// //
// //   // Create tables
// //   static Future<void> _createDB(Database db, int version) async {
// //     await db.execute('''
// //       CREATE TABLE Users(
// //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// //         name TEXT,
// //         email TEXT,
// //         preferences TEXT
// //       )
// //     ''');
// //
// //     await db.execute('''
// //       CREATE TABLE Events(
// //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// //         name TEXT,
// //         date TEXT,
// //         location TEXT,
// //         description TEXT,
// //         userId INTEGER,
// //         FOREIGN KEY(userId) REFERENCES Users(id)
// //       )
// //     ''');
// //
// //     await db.execute('''
// //       CREATE TABLE Gifts(
// //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// //         name TEXT,
// //         description TEXT,
// //         category TEXT,
// //         price REAL,
// //         status TEXT,
// //         eventId INTEGER,
// //         FOREIGN KEY(eventId) REFERENCES Events(id)
// //       )
// //     ''');
// //
// //     await db.execute('''
// //       CREATE TABLE Friends(
// //         userId INTEGER,
// //         friendId INTEGER,
// //         PRIMARY KEY(userId, friendId),
// //         FOREIGN KEY(userId) REFERENCES Users(id),
// //         FOREIGN KEY(friendId) REFERENCES Users(id)
// //       )
// //     ''');
// //   }
// //
// //   // Insert a user
// //   static Future<int> insertUser(Map<String, dynamic> user) async {
// //     final db = await database;
// //     return await db.insert('Users', user);
// //   }
// //
// //   // Insert an event
// //   static Future<int> insertEvent(Map<String, dynamic> event) async {
// //     final db = await database;
// //     return await db.insert('Events', event);
// //   }
// //
// //   // Insert a gift
// //   static Future<int> insertGift(Map<String, dynamic> gift) async {
// //     final db = await database;
// //     return await db.insert('Gifts', gift);
// //   }
// //
// //   // Insert a friend relation
// //   static Future<int> insertFriend(Map<String, dynamic> friend) async {
// //     final db = await database;
// //     return await db.insert('Friends', friend);
// //   }
// //
// //   // Get all users
// //   static Future<List<Map<String, dynamic>>> getUsers() async {
// //     final db = await database;
// //     return await db.query('Users');
// //   }
// //
// //   // Get all events for a user
// //   static Future<List<Map<String, dynamic>>> getEventsForUser(int userId) async {
// //     final db = await database;
// //     return await db.query('Events', where: 'userId = ?', whereArgs: [userId]);
// //   }
// //
// //   // Get all gifts for an event
// //   static Future<List<Map<String, dynamic>>> getGiftsForEvent(int eventId) async {
// //     final db = await database;
// //     return await db.query('Gifts', where: 'eventId = ?', whereArgs: [eventId]);
// //   }
// //
// //   // Get all friends for a user
// //   static Future<List<Map<String, dynamic>>> getFriendsForUser(int userId) async {
// //     final db = await database;
// //     return await db.rawQuery('''
// //       SELECT u.* FROM Users u
// //       JOIN Friends f ON u.id = f.friendId
// //       WHERE f.userId = ?
// //     ''', [userId]);
// //   }
// // }
// // class User {
// //   final int? id;
// //   final String name;
// //   final String email;
// //   final String preferences;
// //
// //   User({this.id, required this.name, required this.email, required this.preferences});
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'name': name,
// //       'email': email,
// //       'preferences': preferences,
// //     };
// //   }
// //
// //   static User fromMap(Map<String, dynamic> map) {
// //     return User(
// //       id: map['id'],
// //       name: map['name'],
// //       email: map['email'],
// //       preferences: map['preferences'],
// //     );
// //   }
// // }
// //
// // class Event {
// //   final int? id;
// //   final String name;
// //   final String date;
// //   final String location;
// //   final String description;
// //   final int userId;
// //
// //   Event({this.id, required this.name, required this.date, required this.location, required this.description, required this.userId});
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'name': name,
// //       'date': date,
// //       'location': location,
// //       'description': description,
// //       'userId': userId,
// //     };
// //   }
// //
// //   static Event fromMap(Map<String, dynamic> map) {
// //     return Event(
// //       id: map['id'],
// //       name: map['name'],
// //       date: map['date'],
// //       location: map['location'],
// //       description: map['description'],
// //       userId: map['userId'],
// //     );
// //   }
// // }
// //
// // class Gift {
// //   final int? id;
// //   final String name;
// //   final String description;
// //   final String category;
// //   final double price;
// //   final String status;
// //   final int eventId;
// //
// //   Gift({this.id, required this.name, required this.description, required this.category, required this.price, required this.status, required this.eventId});
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'name': name,
// //       'description': description,
// //       'category': category,
// //       'price': price,
// //       'status': status,
// //       'eventId': eventId,
// //     };
// //   }
// //
// //   static Gift fromMap(Map<String, dynamic> map) {
// //     return Gift(
// //       id: map['id'],
// //       name: map['name'],
// //       description: map['description'],
// //       category: map['category'],
// //       price: map['price'],
// //       status: map['status'],
// //       eventId: map['eventId'],
// //     );
// //   }
// // }
// //
// // class Friend {
// //   final int userId;
// //   final int friendId;
// //
// //   Friend({required this.userId, required this.friendId});
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'userId': userId,
// //       'friendId': friendId,
// //     };
// //   }
// //
// //   static Friend fromMap(Map<String, dynamic> map) {
// //     return Friend(
// //       userId: map['userId'],
// //       friendId: map['friendId'],
// //     );
// //   }
// // }
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//   static Database? _database;
//
//   DatabaseHelper._privateConstructor();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'events.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute(
//           '''
//           CREATE TABLE events (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT
//           )
//           ''',
//         );
//       },
//     );
//   }
//
//   Future<int> insertEvent(String name) async {
//     Database db = await instance.database;
//     return await db.insert('events', {'name': name});
//   }
//
//   Future<List<Map<String, dynamic>>> getEvents() async {
//     Database db = await instance.database;
//     return await db.query('events');
//   }
// }
