import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as SQL;

class DBFoto {
  static Future<void> creaTabelle(SQL.Database database) async {
    await database.execute(
        """
      CREATE TABLE Foto (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nome VARCHAR(255),
      percorso VARCHAR(255),
      risultato INT NOT NULL,
      misura DOUBLE,
      latitudine DOUBLE,
      longitudine DOUBLE,
      dataCattura VARCHAR(255),
      oraCattura VARCHAR(255)
      );
      """);
    // await database.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (1,'2023-03-06_11_35_05.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:35:05');
    // """);
    // await database.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (2,'2023-03-06_11_37_12.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:37:12');
    // """);
    // await database.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (3,'2023-03-06_11_38_15.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:38:15');
    // """);
    // await database.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (4,'2023-03-06_11_41_01.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:41:01');
    // """);
    // await database.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (5,'2023-03-06_11_42_50.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:42:50');
    // """);
    // await database.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (6,'2023-03-06_11_44_00.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:44:00');
    // """);
  }

  static Future<int> svuotaTabellaFoto() async {
    int risultato = -1;
    final db = await DBFoto.db();
    try {
      risultato = await db.delete("Foto");
    } catch (err) {
      debugPrint("Si è verificato un errore: $err");
    }
    return risultato;
  }

  static Future<void> inserisciDatiProva() async {
    // final db = await DBFoto.db();
    // await db.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (1,'2023-03-06_11_35_05.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:35:05');
    // """);
    // await db.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (2,'2023-03-06_11_37_12.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:37:12');
    // """);
    // await db.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (3,'2023-03-06_11_38_15.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:38:15');
    // """);
    // await db.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (4,'2023-03-06_11_41_01.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:41:01');
    // """);
    // await db.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (5,'2023-03-06_11_42_50.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:42:50');
    // """);
    // await db.execute("""
    //   INSERT INTO "Foto" ("ID","Nome","Percorso","Risultato","Latitudine","Longitudine","DataCattura","OraCattura") VALUES (6,'2023-03-06_11_44_00.jpg','/data/user/0/com.ispascalcomandini.freel/lifeel',-1,44.1957721,12.360901,'2023-03-06','11:44:00');
    // """);
  }

  // Creazione del DB e delle tabelle
  static Future<SQL.Database> db() async {
    return SQL.openDatabase(
      'freel.db',
      version: 1,
      onCreate: (SQL.Database database, int version) async {
        await creaTabelle(database);
      },
    );
  }

  // Aggiunge alla tabella una nuova foto
  static Future<int> creaFoto(String n, String p, int r, double m, double lat,
      double lon, String dcatt, String ocatt) async {
    final db = await DBFoto.db();

    final data = {
      'nome': n,
      'percorso': p,
      'risultato': r,
      'misura': m,
      'latitudine': lat,
      'longitudine': lon,
      'dataCattura': dcatt,
      'oraCattura': ocatt
    };
    final id = await db.insert('Foto', data,
        conflictAlgorithm: SQL.ConflictAlgorithm.replace);
    return id;
  }

  // Restituisce l'elenco di tutte le foto presenti
  static Future<List<Map<String, dynamic>>> getElencoFoto() async {
    final db = await DBFoto.db();
    return db.query('Foto', orderBy: "id");
  }

  // Restituisce la foto con l'id specificato
  static Future<List<Map<String, dynamic>>> getFoto(int id) async {
    final db = await DBFoto.db();
    return db.query('Foto', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<void> cancellaFoto(int id) async {
    final db = await DBFoto.db();
    try {
      await db.delete("Foto", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Si è verificato un errore: $err");
    }
  }
}
