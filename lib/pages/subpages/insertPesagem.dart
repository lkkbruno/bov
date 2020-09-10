import 'dart:ui';
import 'package:appmcpabovino/Database/model/Pesagens.dart';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:postgres/postgres.dart';
import '../../Database/model/Comandos.dart';
import '../../Database/model/Animais.dart';
import '../../Data/GlobalAssets.dart' as globals;

class InsertPesagemStateful extends StatefulWidget {
  InsertPesagemStateful({Key key, this.animal}) : super(key: key);
  final Animais animal;

  @override
  State<StatefulWidget> createState() {
    return Formulario();
  }
}

class Formulario extends State<InsertPesagemStateful> {
  //String identificacaoValue;
  final identificacaoValueText = TextEditingController();
  final codIdentificacaoValue = TextEditingController();
  final quantidadeValue = TextEditingController(text: "1");
  final pesoIndicadoValue = TextEditingController(text: "1000");
  final pesoMedioValue = TextEditingController();

  String rfid;

  void _inserir() async {
    Pesagens pesagem = new Pesagens(
        identificacao: identificacaoValueText.text,
        codidentificacao: codIdentificacaoValue.text,
        animalid: widget.animal.uuid,
        datapesagem: DateTime.now().toString(),
        peso: pesoIndicadoValue.text,
        pesomedio: pesoMedioValue.text,
        quantidade: quantidadeValue.text);

    await DBProvider.db.addPesagem(pesagem);
    var query =
        "INSERT INTO public.pesagemapp(datapesagem, identificacao, codidentificacao, peso, pesomedio, quantidade, status, animalid, cpf)"
        "VALUES ('${DateTime.now().toString()}', '${identificacaoValueText.text}', '${codIdentificacaoValue.text}', '${pesoIndicadoValue.text}', '${pesoMedioValue.text}',"
        "        ${quantidadeValue.text}, '', '${widget.animal.uuid}', '${globals.cpf}')";

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

  List<Widget> children = <Widget>[];

  Future<String> _getPesoIndicador() async {
    var value = '';

    try {
      var client = http.Client();

      String url = "http://192.168.4.1/webapi/api/peso";
      var response = await client
          .get(url)
          .timeout(new Duration(milliseconds: 500))
          .catchError(() {
        value = '1000';
        pesoMedioValue.text =
            (double.parse(value) / int.parse(quantidadeValue.text)).toString();
        return value;
      });

      if (response.body != null) {
        var pesoObj = jsonDecode(response.body);
        String pesoOriginal = pesoObj['Peso'];
        var state = pesoOriginal.substring(0, 1);
        var peso = pesoOriginal.substring(2).replaceAll(new RegExp(r','), '');
        rfid = pesoObj['Rfid'];

        value = double.parse(peso).toString();
      }
      value = '1000';
    } catch (e) {
      value = '1000';
    }

    pesoMedioValue.text =
        (double.parse(value) / int.parse(quantidadeValue.text)).toString();
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PESAGEM"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                              controller: identificacaoValueText
                                ..text = widget.animal.identificacao,
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Identificação',
                                labelStyle: TextStyle(color: Colors.black),
                              )),

                          //CODIGO IDENTIFICACAO
                          TextFormField(
                              controller: codIdentificacaoValue
                                ..text = widget.animal.codidentificacao,
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Codigo de identificação',
                                labelStyle: TextStyle(color: Colors.black),
                              )),
                          //QUANTIDADE
                          TextFormField(
                              controller: quantidadeValue,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: 'Quantidade',
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  if (!(["", null]
                                          .contains(pesoIndicadoValue.text) &&
                                      ["", null]
                                          .contains(quantidadeValue.text))) {
                                    pesoMedioValue.text =
                                        (double.parse(pesoIndicadoValue.text) /
                                                int.parse(quantidadeValue.text))
                                            .toString();
                                  }
                                });
                              }),

                          //PESO INDICADO
                          FutureBuilder(
                              future: _getPesoIndicador(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data != null) {
                                    pesoIndicadoValue.text = snapshot.data;
                                    children = <Widget>[
                                      TextFormField(
                                          controller: pesoIndicadoValue,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Peso Indicado (kg)',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              if (!(["", null].contains(
                                                      pesoIndicadoValue.text) &&
                                                  ["", null].contains(
                                                      quantidadeValue.text))) {
                                                pesoMedioValue
                                                    .text = (double.parse(
                                                            pesoIndicadoValue
                                                                .text) /
                                                        int.parse(
                                                            quantidadeValue
                                                                .text))
                                                    .toString();
                                              }
                                            });
                                          })
                                    ];
                                  } else {
                                    children = <Widget>[
                                      TextFormField(
                                          controller: pesoIndicadoValue,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Peso Indicado (kg)',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              if (!(["", null].contains(
                                                      pesoIndicadoValue.text) &&
                                                  ["", null].contains(
                                                      quantidadeValue.text))) {
                                                pesoMedioValue
                                                    .text = (double.parse(
                                                            pesoIndicadoValue
                                                                .text) /
                                                        int.parse(
                                                            quantidadeValue
                                                                .text))
                                                    .toString();
                                              }
                                            });
                                          })
                                    ];
                                  }
                                }
                                return Column(
                                  children: children,
                                );
                              }),

                          //PESO MEDIO
                          TextFormField(
                              controller: pesoMedioValue
                                ..text = (double.parse(pesoIndicadoValue.text) /
                                        int.parse(quantidadeValue.text))
                                    .toString(),
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Peso médio (kg)',
                                labelStyle: TextStyle(color: Colors.black),
                              )),
                        ],
                      ),
                    ),
                  ),
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
          ),
        ));
  }
}
