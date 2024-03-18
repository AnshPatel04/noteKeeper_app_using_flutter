import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDataBase{

  Future<Database> openAccessDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath.toString(),'note_keeper.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE NOTES(NoteId INTEGER PRIMARY KEY autoincrement,Title Text,Description Text,Date Text,Priority INTEGER)');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute('CREATE TABLE USER(UserId INTEGER PRIMARY KEY autoincrement, UserName Text, UserPassword Text)');
      },
    );
    return db;
  }

  Future<int> insertNoteInNotes(Map<String,Object?> values) async {
    Database db = await openAccessDatabase();
    return await db.insert('NOTES', values);
  }

  Future<int> updateNoteInNotes(Map<String,Object?> values,int id) async {
    Database db = await openAccessDatabase();
    return await db.update('NOTES', values, where: 'NoteId = $id');
  }

  Future<List<Map<String, dynamic>>> getNotesFromTable () async {
    Database db = await openAccessDatabase();
    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    // var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    List<Map<String, dynamic>> noteList = await db.query('NOTES', orderBy: 'Priority ASC');
    return noteList;
  }

  Future<List<Map<String, dynamic>>> getNoteByIdFromTable (int id) async {
    Database db = await openAccessDatabase();
    List<Map<String, dynamic>> noteId = await db.rawQuery('SELECT * FROM NOTES WHERE NoteId = $id');
    return noteId;
  }
  Future<int> deleteNote (int id) async {
    Database db = await openAccessDatabase();
    // int result = await db.rawDelete('DELETE FROM NOTES WHERE NoteId = $id');
    int result = await db.delete('NOTES',where: 'NoteId = ? ',whereArgs: [id]);
    return result;
  }

}