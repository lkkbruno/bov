import 'dart:convert';

Login animaisFromJson(String str) {
  final jsonData = json.decode(str);
  return Login.fromMap(jsonData);
}

String clientToJson(Login data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Login {
  int id;
  String currentSession;

  Login({this.id, this.currentSession});

  factory Login.fromMap(Map<String, dynamic> json) =>
      new Login(id: json["id"], currentSession: json["currentSession"]);

  Map<String, dynamic> toMap() => {"id": id, "currentSession": currentSession};
}
