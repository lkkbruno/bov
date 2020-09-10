import 'dart:convert';

Categorias categoriasFromJson(String str) {
  final jsonData = json.decode(str);
  return Categorias.fromMap(jsonData);
}

String clientToJson(Categorias data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Categorias {
  int id;
  String categoria;
  bool checked;

  Categorias({this.id, this.categoria, this.checked});

  factory Categorias.fromMap(Map<String, dynamic> json) => new Categorias(
      id: json["id"],
      categoria: json["categoria"],
      checked: json["checked"] == "true");

  Map<String, dynamic> toMap() =>
      {"id": id, "categoria": categoria, "checked": checked};
}
