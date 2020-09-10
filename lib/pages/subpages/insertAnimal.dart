import 'dart:ui';
import 'package:appmcpabovino/Database/model/Animais.dart';
import 'package:appmcpabovino/Database/model/Categorias.dart';
import 'package:appmcpabovino/Database/model/Comandos.dart';
import 'package:appmcpabovino/Database/model/Racas.dart';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import 'package:http/http.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';
import '../../Data/GlobalAssets.dart' as globals;

class InsertAnimal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ANIMAL"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: InsertAnimalStateful(),
        ));
  }
}

class InsertAnimalStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Formulario();
  }
}

class Formulario extends State<InsertAnimalStateful> {
  String identificacaoValue;
  final codIdentificacaoValue = TextEditingController();
  final pesoEntradaValue = TextEditingController();
  final pesoIndicadorValue = TextEditingController(text: "1000");
  String sexoValue;
  final idadeValue = TextEditingController();
  final loteValue = TextEditingController(text: "0");
  String categoriaValue;
  String racaValue;
  String origemValue;

  void _inserir() async {
    var uuid = Uuid().v1();

    Animais animal = new Animais(
        uuid: uuid,
        identificacao: identificacaoValue,
        codidentificacao: codIdentificacaoValue.text,
        pesoentrada: pesoEntradaValue.text,
        pesoindicador: pesoIndicadorValue.text,
        sexo: sexoValue,
        idade: int.parse(idadeValue.text),
        lote: loteValue.text,
        categoria: categoriaValue,
        raca: racaValue,
        produtororigem: origemValue,
        dataentrada: DateTime.now().toString());

    await DBProvider.db.addAnimal(animal);

    var query =
        "INSERT INTO public.animalapp(dataentrada, stringdataentrada, identificacao, codidentificacao, pesoentrada, pesoindicador, sexo, idade, lote,"
        "categoria, raca, produtororigem, status, cpf, uuid)"
        "VALUES ('${DateTime.now().toString()}', '${DateTime.now().toString()}', '$identificacaoValue', '${codIdentificacaoValue.text}',"
        " '${pesoEntradaValue.text}', '${pesoIndicadorValue.text}', '$sexoValue', ${int.parse(idadeValue.text)}, '${loteValue.text}', "
        " '$categoriaValue', '$racaValue', '$origemValue', '', '${globals.cpf}', '$uuid')";

    try {
      final connection = new PostgreSQLConnection(globals.connection.host,
          globals.connection.port, globals.connection.databaseName,
          username: globals.connection.username,
          password: globals.connection.password);
      await connection.open();
      await connection.transaction((trans) async {
        await trans.query(query);
      });
    } catch (e) {
      var ex = e;
      Comandos comando = new Comandos(command: query, executed: false);
      await DBProvider.db.addCommand(comando);
    }

    Navigator.pop(context);
  }

  Future<String> _getPesoIndicador() async {
    try {
      String url = "http://192.168.4.1/webapi/api/peso";
      Response response = await get(url);
      if (response.body != null) {
        var palavras = response.body.split('p');
        var peso = palavras[2].substring(2);
        return peso;
      }
      return '2';
    } catch (e) {}
  }

  Future<List<Categorias>> getCategorias() async {
    return await DBProvider.db.getCategoriasChecked();
  }

  Future<List<Racas>> getRacas() async {
    return await DBProvider.db.getRacasChecked();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: _getPesoIndicador(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List children = <Widget>[];
                  String pesoIndicador = '';
                  if (snapshot.hasData) {
                    pesoIndicador = snapshot.data;
                  }
                  children = <Widget>[
                    Form(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //IDENTIFICACAO
                            DropdownButtonFormField<String>(
                              decoration:
                                  InputDecoration(labelText: "Identificação"),
                              isExpanded: true,
                              value: identificacaoValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              onChanged: (String newValue) {
                                setState(() {
                                  identificacaoValue = newValue;
                                });
                              },
                              items: <String>[
                                'BRINCO',
                                'SISBOV',
                                'MARCA',
                                'RFID'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),

                            //CODIGO IDENTIFICACAO
                            TextFormField(
                                controller: codIdentificacaoValue,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Codigo de identificação',
                                  labelStyle: TextStyle(color: Colors.black),
                                )),

                            //PESOENTRADA / PESOINDICADOR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 1.5, 0),
                                    child: //PESOENTRADA
                                        TextFormField(
                                            controller: pesoEntradaValue,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Peso de entrada (kg)',
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                            )),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(1.5, 0, 0, 0),
                                    child: //PESO INDICADOR
                                        TextFormField(
                                            controller: pesoIndicadorValue,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Peso indicador (kg)',
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                            )),
                                  ),
                                ),
                              ],
                            ),

                            //SEXO
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: "Sexo"),
                              isExpanded: true,
                              value: sexoValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              onChanged: (String newValue) {
                                setState(() {
                                  sexoValue = newValue;
                                });
                              },
                              items: <String>[
                                'Macho',
                                'Fêmea'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),

                            //IDADE / LOTE
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 1.5, 0),
                                    child: //IDADE
                                        TextFormField(
                                            controller: idadeValue,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Idade (dias)',
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                            )),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(1.5, 0, 0, 0),
                                    child: //LOTE
                                        TextFormField(
                                            controller: loteValue,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Lote',
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                            )),
                                  ),
                                )
                              ],
                            ),

                            //CATEGORIA
                            FutureBuilder(
                                future: getCategorias(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Categorias>> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data != null) {
                                      var lista = new List<String>();
                                      for (var item in snapshot.data) {
                                        lista.add(item.categoria);
                                      }

                                      children = <Widget>[
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                              labelText: "Categoria"),
                                          isExpanded: true,
                                          value: categoriaValue,
                                          icon: Icon(Icons.arrow_downward),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              categoriaValue = newValue;
                                            });
                                          },
                                          items: lista
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      ];
                                    }
                                  } else if (snapshot.hasError) {
                                    children = <Widget>[];
                                  } else {
                                    children = <Widget>[];
                                  }
                                  return Column(children: children);
                                }),

                            //RAÇA
                            FutureBuilder(
                                future: getRacas(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Racas>> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data != null) {
                                      var lista = new List<String>();
                                      for (var item in snapshot.data) {
                                        lista.add(item.raca);
                                      }

                                      children = <Widget>[
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                              labelText: "Raça"),
                                          isExpanded: true,
                                          value: racaValue,
                                          icon: Icon(Icons.arrow_downward),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              racaValue = newValue;
                                            });
                                          },
                                          items: lista
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      ];
                                    }
                                  } else if (snapshot.hasError) {
                                    children = <Widget>[];
                                  } else {
                                    children = <Widget>[];
                                  }
                                  return Column(children: children);
                                }),

                            //ORIGEM
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: "Origem"),
                              isExpanded: true,
                              value: origemValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              onChanged: (String newValue) {
                                setState(() {
                                  origemValue = newValue;
                                });
                              },
                              items: <String>[
                                'Padrão'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                  return Column(children: children);
                }),
          ),
        ),
        ButtonTheme(
          minWidth: 300,
          height: 40,
          child: RaisedButton(
            onPressed: () {
              this._inserir();
            },
            color: Colors.deepPurpleAccent,
            child: const Text('SALVAR', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }
}
