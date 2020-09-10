import 'dart:convert';

Comandos comandosFromJson(String str) {
  final jsonData = json.decode(str);
  return Comandos.fromMap(jsonData);
}

String clientToJson(Comandos data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Comandos {
  int id;
  String command;
  bool executed;

  Comandos({this.id, this.command, this.executed});

  factory Comandos.fromMap(Map<String, dynamic> json) => new Comandos(
      id: json["id"], command: json["command"], executed: json["executed"]);

  Map<String, dynamic> toMap() =>
      {"id": id, "command": command, "executed": executed};
}
