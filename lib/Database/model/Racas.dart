import 'dart:convert';

Racas racasFromJson(String str) {
  final jsonData = json.decode(str);
  return Racas.fromMap(jsonData);
}

String clientToJson(Racas data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Racas {
  int id;
  String raca;
  bool checked;

  Racas({this.id, this.raca, this.checked});

  factory Racas.fromMap(Map<String, dynamic> json) => new Racas(
      id: json["id"], raca: json["raca"], checked: json["checked"] == "true");

  Map<String, dynamic> toMap() => {"id": id, "raca": raca, "checked": checked};
}
