import 'dart:convert';

Animais animaisFromJson(String str) {
  final jsonData = json.decode(str);
  return Animais.fromMap(jsonData);
}

String clientToJson(Animais data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Animais {
  int id;
  String uuid;
  String dataentrada;
  String identificacao;
  String codidentificacao;
  String pesoentrada;
  String pesoindicador;
  String sexo;
  int idade;
  String lote;
  String categoria;
  String raca;
  String produtororigem;
  String status;

  Animais(
      {this.id,
      this.uuid,
      this.dataentrada,
      this.identificacao,
      this.codidentificacao,
      this.pesoentrada,
      this.pesoindicador,
      this.sexo,
      this.idade,
      this.lote,
      this.categoria,
      this.raca,
      this.produtororigem,
      this.status});

  factory Animais.fromMap(Map<String, dynamic> json) => new Animais(
      id: json["id"],
      uuid: json["uuid"],
      dataentrada: json["dataentrada"],
      identificacao: json["identificacao"],
      codidentificacao: json["codidentificacao"],
      pesoentrada: json["pesoentrada"],
      pesoindicador: json["pesoindicador"],
      sexo: json["sexo"],
      idade: json["idade"],
      lote: json["lote"],
      categoria: json["categoria"],
      raca: json["raca"],
      produtororigem: json["produtororigem"],
      status: json["status"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "uuid": uuid,
        "dataentrada": dataentrada,
        "identificacao": identificacao,
        "codidentificacao": codidentificacao,
        "pesoentrada": pesoentrada,
        "pesoindicador": pesoindicador,
        "sexo": sexo,
        "idade": idade,
        "lote": lote,
        "categoria": categoria,
        "raca": raca,
        "produtororigem": produtororigem,
        "status": status
      };
}
