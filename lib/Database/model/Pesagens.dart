import 'dart:convert';

Pesagens pesagensFromJson(String str) {
  final jsonData = json.decode(str);
  return Pesagens.fromMap(jsonData);
}

String clientToJson(Pesagens data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Pesagens {
  int id;
  String animalid;
  String datapesagem;
  String identificacao;
  String codidentificacao;
  String peso;
  String pesomedio;
  String quantidade;
  String status;

  Pesagens(
      {this.id,
      this.animalid,
      this.datapesagem,
      this.identificacao,
      this.codidentificacao,
      this.peso,
      this.pesomedio,
      this.quantidade,
      this.status});

  factory Pesagens.fromMap(Map<String, dynamic> json) => new Pesagens(
      id: json["id"],
      animalid: json["animalid"],
      datapesagem: json["datapesagem"],
      identificacao: json["identificacao"],
      codidentificacao: json["codidentificacao"],
      peso: json["peso"],
      pesomedio: json["pesomedio"],
      quantidade: json["quantidade"],
      status: json["status"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "animalid": animalid,
        "datapesagem": datapesagem,
        "identificacao": identificacao,
        "codidentificacao": codidentificacao,
        "peso": peso,
        "pesomedio": pesomedio,
        "quantidade": quantidade,
        "status": status
      };
}
