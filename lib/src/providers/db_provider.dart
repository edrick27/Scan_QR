import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_scanner/src/models/scan_model.dart';
export 'package:qr_scanner/src/models/scan_model.dart';

class DBProvider {
  
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();//constructor privado para que solo exista una instancia

  Future<Database> get database async {

    if(_database != null) return _database;

    _database = await initDB();

    return _database;

  }

  Future initDB() async {

    //path de donde esta la base de datos
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        await db.execute(
          'CREATE TABLE scans ('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')'
        );
      }
    );

  }


  // CREAR REGISTROS
  newScanRaw(ScanModel nuevoScan) async{
    final db = await database;

    final res = await db.rawInsert(
      "INSERT INTO scans (id, tipo, valor) "
      "VALUES ( ${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')"
    );

    return res;

  }

  // CREAR REGISTROS
  newScan(ScanModel nuevoScan) async{
    final db = await database;

    final res = await db.insert("scans", nuevoScan.toJson());

    return res;

  }

  //obtener registros
  Future<ScanModel> getScanId( int id ) async {
    final db = await database;

    final res = await db.query(
      'scans', 
      where: 'id = ?',
      whereArgs: [id]
    );

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;

    final res = await db.query('scans');

    List<ScanModel> list =  res.isNotEmpty 
                                ? res.map((s) =>  ScanModel.fromJson(s)).toList() 
                                : [];

    return list;
  }

  Future<List<ScanModel>> getScansporTipo( String tipo ) async {
    
    final db = await database;

    final res = await db.rawQuery("SELECT * FROM scans WHERE tipo '$tipo'");

    List<ScanModel> list =  res.isNotEmpty 
                                ? res.map((s) =>  ScanModel.fromJson(s)).toList() 
                                : [];

    return list;
  }

  //actualizar tipos
  Future<int> updateScan(ScanModel nuevoScan)  async{

    final db = await database;
    final res = await db.update(
      "scans", 
      nuevoScan.toJson(),
      where: "id = ?",
      whereArgs: [nuevoScan.id]   
    );

     return res;
  }

  //eliminar registros
  Future<int> deleteScan(int id)  async{

    final db = await database;
    final res = await db.delete(
      "scans", 
      where: "id = ?",
      whereArgs: [id]   
    );

     return res;
  }

   Future<int> deleteAllScan()  async{

    final db = await database;
    final res = await db.rawDelete("DELETE FROM scans");

     return res;
  }

}