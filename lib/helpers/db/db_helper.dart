import 'package:farmer_app/helpers/db/sqf_object.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

class DBHelper<T extends MJObject<T>> {
  // late Future<Database> _database;
  Completer<Database>? _dbOpenCompleter;

  // static final MJAppDatabase _instanceLittrel = MJAppDatabase._();
  // MJAppDatabase dbRef = MJAppDatabase.instance;
  Future<Database> get db async => database;
  String? storeName;
  T? obj;

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer<Database>();
      _openDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  Future<dynamic> _openDatabase() async {
    var db = await openDatabase(
      join(await getDatabasesPath(), 'pich'),
      version: 1,
    );
    _dbOpenCompleter!.complete(db);
  }

  Future<bool> init(T object, String query, storeName) async {
    print(storeName);
    this.storeName = storeName;
    this.obj = object;
    try {
      Database database = await db;
      database.execute(query);
    } on DatabaseException catch (_, database) {
      print(_);
    }
    return true;
  }

  Future<dynamic> insert(T object) async {
    Database database = await db;
    var id = await database.insert(storeName!, obj!.toMap(object));
    return id;
  }

  Future<int> deleteOne(String col, String value) async {
    Database database = await db;
    return await database
        .delete(storeName!, where: '$col = ?', whereArgs: [value]);
  }

  Future<int> deleteAll() async {
    Database database = await db;
    print(storeName!);
    return await database.rawDelete("delete from " + storeName!);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database database = await db;
    List<Map<String, dynamic>> maps = await database.query(storeName!);
    if (maps.length > 0) {
      return maps;
    }
    return [];
  }

  Future<int> updateObjWhere(
      T obj, List<String> cols, List<String> vals) async {
    Database database = await db;
    String concatCols = '';
    int cl = 0;
    for (String col in cols) {
      cl++;
      concatCols += '$col=?';
      if (cl != cols.length) concatCols += ' AND ';
    }

    // int count = await database.rawUpdate(
    //     'UPDATE ${storeName!} SET ${concatCols} WHERE ${concatCols}',
    //     [...vals]);
    return await database.update(storeName!, obj.toMap(obj),
        where: '${concatCols}', whereArgs: [...vals]);
  }
  Future<int> updateWhere(List<String> cols,List<String> vals,List<String> whereCols,List<String> whereVals)async{
    Database database = await db;
    String concatCols = '';
    int cl = 0;
    for(String col in cols){
      cl++;
      concatCols += '$col=?';
      if(cl != cols.length)  concatCols+=',';
    }
    String whereConcatCols = '';
    int whereCl = 0;
    for(String col in whereCols){
      whereCl++;
      whereConcatCols += '$col=?';
      if(whereCl != whereCols.length)  whereConcatCols+=' AND ';
    }

    int count = await database.rawUpdate(
        'UPDATE ${storeName!} SET ${concatCols} WHERE ${whereConcatCols}',
        [...vals,...whereVals]);
    return count;
  }
  Future<List<Map<String, dynamic>>> getAllWhere(List<String> cols,List<String> vals) async {
    Database database = await db;
    String concatCols = '';
    int cl = 0;
    for(String col in cols){
      cl++;
      concatCols += '$col=?';
      if(cl != cols.length)  concatCols+=' And ';
    }

    List<Map<String, dynamic>> maps = await database.query(storeName!,where: '$concatCols',whereArgs: [...vals]);
    if (maps.length > 0) {
      return maps;
    }
    return [];
  }


}
