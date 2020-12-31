import 'package:note_app/notedb/note.dart';
import 'package:sqflite/sqflite.dart';
//path_provider package
import 'package:path/path.dart'; //used to join paths

class Notedb {
  Future<Database> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db'); //create path to database

    return await openDatabase(
        //open the database or create a database if there isn't any
        path,
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE note(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          desc TEXT)""");
    });
  }

  Future<int> addItem(Note item) async {
    //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert(
      "note", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm:
          ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<Note>> fetchNotes(String search) async {
    final db = await init();
    //returns the memos as a list (array)
    if (search.length < 1) {
      final maps = await db
          .query("note"); //query all the rows in a table as an array of maps

      return List.generate(maps.length, (i) {
        //create a list of memos
        return Note(
          id: maps[i]['id'],
          title: maps[i]['title'],
          desc: maps[i]['desc'],
        );
      });
    } else {
      final maps = await db.query("note",
          where: "title LIKE ?",
          whereArgs: [
            '%$search%'
          ]); //query all the rows in a table as an array of maps

      return List.generate(maps.length, (i) {
        //create a list of memos
        return Note(
          id: maps[i]['id'],
          title: maps[i]['title'],
          desc: maps[i]['desc'],
        );
      });
    }
  }

  Future<Note> fetchNote(int id) async {
    //returns the memos as a list (array)
    final db = await init();
    final maps = await db.query("note",
        where: "id = ?",
        whereArgs: [id]); //query all the rows in a table as an array of maps
    if (maps.length > 0) {
      return Note(
        id: maps[0]['id'],
        title: maps[0]['title'],
        desc: maps[0]['desc'],
      );
    }

    return null;
  }

  Future<int> deleteNote(int id) async {
    //returns number of items deleted
    final db = await init();
    int result = await db.delete(
      "note", //table name
      where: "id = ?",
      whereArgs: [id], // use whereArgs to avoid SQL injection
    );

    return result;
  }

  Future<int> updateNote(int id, Note item) async {
    // returns the number of rows updated
    final db = await init();
    int result =
        await db.update("note", item.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}
