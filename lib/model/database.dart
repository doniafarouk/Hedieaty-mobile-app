import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Event {
  final int? id;
  final String name;
  final String date;
  final String location;
  final String description;
  final int userId;

  Event({
    this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'userId': userId,
    };
  }
}

class Gift {
  final int? id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final int eventId;


  Gift({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
  });

  // Convert a Gift object into a Map for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'eventId': eventId,
    };
  }

  // Convert a Map into a Gift object
  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      status: map['status'],
      eventId: map['eventId'],
    );
  }
}


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE
          );
        ''');
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            date TEXT,
            location TEXT,
            description TEXT,
            userId INTEGER,
            FOREIGN KEY (userId) REFERENCES users (id)
          );
        ''');
        await db.execute('PRAGMA foreign_keys = ON;');  // Enable foreign keys
      },
    );
  }

  // Add method to check and create tables
  // Add method to check and create tables
  Future<void> checkAndCreateTables() async {
    final db = await database;
    final result = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table" AND name="gifts"');
    if (result.isEmpty) {
      // Create the gifts table if it doesn't exist
      await db.execute('''CREATE TABLE gifts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT, category TEXT NOT NULL, price REAL NOT NULL, status TEXT DEFAULT "Available", eventId INTEGER NOT NULL, FOREIGN KEY (eventId) REFERENCES events (id));''');
    }
  }



  Future<bool> doesUserExist(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // User Table Operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Update user
  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    final db = await database;
    await db.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Function to get the userId from the local database by email
  // Future<int?> getUserIdByEmail(String email) async {
  //   final db = await database;
  //   final result = await db.query(
  //     'users',
  //     where: 'email = ?',
  //     whereArgs: [email],
  //   );
  //
  //   if (result.isNotEmpty) {
  //     return result.first['id'] as int?;
  //   } else {
  //     return null; // Return null if no user is found
  //   }
  // }
  // Future<int?> getUserIdByEmail(String email) async {
  //   final db = await database; // Get the SQLite database
  //   List<Map<String, dynamic>> result = await db.query(
  //     'users',
  //     where: 'email = ?',
  //     whereArgs: [email],
  //   );
  //
  //   if (result.isNotEmpty) {
  //     return result.first['id']; // Return the correct userId from SQLite
  //   } else {
  //     return null;  // Return null if no user is found with the given email
  //   }
  // }

  Future<int?> getUserIdByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int?;
    }
    return null;
  }



  // Event Table Operations
  Future<int> insertEvent(Event event) async {
    final db = await database;
    return await db.insert('events', event.toMap());
  }

  Future<List<Event>> getEvents(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        name: maps[i]['name'],
        date: maps[i]['date'],
        location: maps[i]['location'],
        description: maps[i]['description'],
        userId: maps[i]['userId'],
      );
    });
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [event.id, event.userId],
    );
  }

  Future<int> deleteEvent(int id, int userId) async {
    final db = await database;
    return await db.delete(
      'events',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  // Insert a gift using the Gift model directly
  Future<int> insertGift(Gift gift) async {
    final db = await database;
    return await db.insert(
      'gifts',
      gift.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,  // Handle conflict
    );
  }

  // Retrieve gifts for a specific event
  Future<List<Gift>> getGifts(int eventId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'gifts',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );

    return List.generate(maps.length, (i) {
      return Gift.fromMap(maps[i]);
    });
  }

// Update a gift
  Future<int> updateGift(int giftId, Map<String, dynamic> giftData) async {
    final db = await database;
    return await db.update(
      'gifts',
      giftData,
      where: 'id = ?',
      whereArgs: [giftId],

    );
  }

  // Update the name of a gift
  Future<int> updateGiftName(int giftId, String newName) async {
    final db = await database;
    return await db.update(
      'gifts',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [giftId],
    );
  }

// Delete a gift
  Future<int> deleteGift(int giftId) async {
    final db = await database;
    return await db.delete(
      'gifts',
      where: 'id = ?',
      whereArgs: [giftId],
    );
  }

  // Update the status of a gift (e.g., mark it as 'Pledged')
  Future<int> updateGiftStatus(int giftId, String status) async {
    final db = await database;
    return await db.update(
      'gifts',
      {'status': status}, // Set the new status
      where: 'id = ?',
      whereArgs: [giftId],
    );
  }



  Future<void> close() async {
    final db = await database;
    db.close();
  }
}


