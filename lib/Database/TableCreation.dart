class TableCreation {
  static const String stringCreationAnimais = "CREATE TABLE Animais ("
      "  id INTEGER PRIMARY KEY,"
      "  uuid TEXT,"
      "  dataentrada TEXT,"
      "  identificacao TEXT,"
      "  codidentificacao TEXT,"
      "  pesoentrada TEXT,"
      "  pesoindicador TEXT,"
      "  sexo TEXT,"
      "  idade INTEGER,"
      "  lote TEXT,"
      "  categoria TEXT,"
      "  raca TEXT,"
      "  produtororigem TEXT,"
      "  status TEXT);";

  static const String stringCreationLogin = "CREATE TABLE Login (       "
      "  id INTEGER PRIMARY KEY,"
      "  currentSession TEXT)";

  static const String stringCreationPesagens = "CREATE TABLE Pesagens ("
      " id INTEGER PRIMARY KEY,"
      " animalid TEXT,"
      " datapesagem TEXT,"
      " identificacao TEXT,"
      " codidentificacao TEXT,"
      " peso TEXT,"
      " pesomedio TEXT,"
      " quantidade TEXT,"
      " status TEXT);";

  static const String stringCreatingComandos = "CREATE TABLE Comandos("
      " id INTEGER PRIMARY KEY,"
      " command TEXT,"
      " executed BOOLEAN);";

  static const String stringCreatingCategorias = "CREATE TABLE Categorias("
      " id INTEGER PRIMARY KEY,"
      " categoria TEXT,"
      " checked BOOLEAN);";

  static const String stringCreateCategoriasValues =
      "INSERT INTO Categorias(categoria, checked) VALUES ('Touro', 'true'), ('Novilho', 'true'), ('Garrote', 'true'), ('Bezerro', 'true'), ('Suíno', 'true');";

  static const String stringCreatingRacas = "CREATE TABLE Racas("
      " id INTEGER PRIMARY KEY,"
      " raca TEXT, "
      " checked BOOLEAN)";

  static const String stringCreateRacasValues =
      "INSERT INTO Racas(raca, checked) VALUES ('Nelore', 'true'), ('Angus', 'true'), ('Braler', 'true'), ('Brangus', 'true');";
}
