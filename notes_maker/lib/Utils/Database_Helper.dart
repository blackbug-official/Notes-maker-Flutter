import 'package:notes_maker/Screens/Note_details.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notes_maker/Models/Notes.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //singleton object(singleton -> only one instance is created per application opened, and instance destroyed when app closes)
  static Database _database; //singleton database object

  //declaring table and data in table
  String noteTable = 'Note_table'; //table declaration
  String colId = 'id'; // column name = data in column
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance(); //named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    //Factory key word allows us to return any type of object
    if (_databaseHelper == null) {
      //create instance only if already not available
      _databaseHelper = DatabaseHelper
          ._createInstance(); //this is executed only once , singleton object
    }
    return _databaseHelper;
  }

// function to create database
  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  Future<Database> get database async {
    //getter for database

    if (_database == null) {
      //since database is singleton, checking for null reference
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
// Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

// Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return notesDatabase;
  }

// Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

// Insert Operation: Insert a Note object to database
  Future<int> insertNote(Notes note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

// Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Notes note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

// Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

// Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

// Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Notes>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Notes> noteList = List<Notes>();
// For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Notes.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
