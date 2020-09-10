import 'dart:async';
import 'dart:io';
import 'package:appmcpabovino/Database/TableCreation.dart';
import 'package:appmcpabovino/Database/model/Pesagens.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model/Animais.dart';
import 'model/Categorias.dart';
import 'model/Login.dart';
import 'model/Comandos.dart';
import 'model/Racas.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "bovdb.db");

    return await openDatabase(path, version: 1, onCreate: this._onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(TableCreation.stringCreationAnimais);
    await db.execute(TableCreation.stringCreationLogin);
    await db.execute(TableCreation.stringCreationPesagens);
    await db.execute(TableCreation.stringCreatingComandos);
    await db.execute(TableCreation.stringCreatingCategorias);
    await db.execute(TableCreation.stringCreatingRacas);
    await db.execute(TableCreation.stringCreateCategoriasValues);
    await db.execute(TableCreation.stringCreateRacasValues);
  }

  //TODO Transferir CRUD para arquivos individuais para melhor organização
  //ANIMAIS
  addAnimal(Animais animal) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Animais");
    animal.id = table.first["id"];
    var res = await db.insert("Animais", animal.toMap());
    return res;
  }

  getAnimal(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Animais.fromMap(res.first) : Null;
  }

  getAllAnimais() async {
    final db = await database;
    var res = await db.query("Animais");
    List<Animais> list =
        res.isNotEmpty ? res.map((c) => Animais.fromMap(c)).toList() : [];
    return list;
  }

  deleteAnimal(int id) async {
    final db = await database;
    db.delete("Animais", where: "id = ?", whereArgs: [id]);
  }

  //LOGIN
  addLogin(Login login) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Login");
    login.id = table.first["id"];
    var res = await db.insert("Login", login.toMap());
    return res;
  }

  updateLogin(Login login) async {
    final db = await database;
    var res = await db.update("Login", login.toMap());
    return res;
  }

  getAllLogin() async {
    final db = await database;
    var res = await db.query("Login");
    List<Login> list =
        res.isNotEmpty ? res.map((c) => Login.fromMap(c)).toList() : [];
    return list;
  }

  //PESAGENS
  addPesagem(Pesagens pesagem) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Pesagens");
    pesagem.id = table.first["id"];
    var res = await db.insert("Pesagens", pesagem.toMap());
    return res;
  }

  deletePesagem(int id) async {
    final db = await database;
    db.delete("Pesagens", where: "id = ?", whereArgs: [id]);
  }

  getPesagensAnimalUuid(String uuid) async {
    final db = await database;
    var res =
        await db.query("Pesagens", where: "animalid = ?", whereArgs: [uuid]);
    List<Pesagens> list =
        res.isNotEmpty ? res.map((c) => Pesagens.fromMap(c)).toList() : [];
    return list;
  }

  updatePesagens(Pesagens pesagem) async {
    final db = await database;
    var res = await db.update("Pesagens", pesagem.toMap());
    return res;
  }

  //COMANDOS
  getComandosNotExecuted() async {
    final db = await database;
    var res = await db.query("Comandos", where: "executed = false");
    List<Comandos> list =
        res.isNotEmpty ? res.map((x) => Comandos.fromMap(x)).toList() : [];
    return list;
  }

  addCommand(Comandos comando) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) + 1 as id FROM Comandos");
    comando.id = table.first["id"];
    var res = await db.insert("Comandos", comando.toMap());
    return res;
  }

  updateCommand(Comandos comando) async {
    final db = await database;
    var res = await db.update("Comandos", comando.toMap());
    return res;
  }

  //CATEGORIAS
  getAllCategorias() async {
    final db = await database;
    var res = await db.query("Categorias");
    List<Categorias> list =
        res.isNotEmpty ? res.map((c) => Categorias.fromMap(c)).toList() : [];
    return list;
  }

  getCategoriasChecked() async {
    final db = await database;
    var res = await db.query("Categorias", where: "checked = 'true'");
    List<Categorias> list =
        res.isNotEmpty ? res.map((c) => Categorias.fromMap(c)).toList() : [];

    return list;
  }

  addCategoria(Categorias comando) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) + 1 as id FROM Categorias");
    comando.id = table.first["id"];
    var res = await db.insert("Categorias", comando.toMap());
    return res;
  }

  updateCategoria(Categorias comando) async {
    final db = await database;
    var res = await db.update("Categorias", comando.toMap());
    return res;
  }

  updateCategoriaCheck(int id, bool checked) async {
    final db = await database;
    await db
        .execute("UPDATE Categorias SET checked = '$checked' WHERE id = $id");
  }

  //RACAS
  getAllRacas() async {
    final db = await database;
    var res = await db.query("Racas");
    List<Racas> list =
        res.isNotEmpty ? res.map((c) => Racas.fromMap(c)).toList() : [];
    return list;
  }

  getRacasChecked() async {
    final db = await database;
    var res = await db.query("Racas", where: "checked = 'true'");
    List<Racas> list =
        res.isNotEmpty ? res.map((c) => Racas.fromMap(c)).toList() : [];
    return list;
  }

  addRaca(Racas comando) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id) + 1 as id FROM Racas");
    comando.id = table.first["id"];
    var res = await db.insert("Racas", comando.toMap());
    return res;
  }

  updateRaca(Racas comando) async {
    final db = await database;
    var res = await db.update("Racas", comando.toMap());
    return res;
  }

  updateRacaCheck(int id, bool checked) async {
    final db = await database;
    await db.execute("UPDATE Racas SET checked = '$checked' WHERE id = $id");
  }
}
