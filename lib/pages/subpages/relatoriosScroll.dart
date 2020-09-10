import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';
import 'package:appmcpabovino/Database/model/Animais.dart';
import 'package:appmcpabovino/Database/model/Pesagens.dart';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class Relatorios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("RELATÓRIOS"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: RelatoriosStatefulScroll(),
        ));
  }
}

class RelatoriosStatefulScroll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RelatoriosListItem();
  }
}

class RelatoriosListItem extends State<RelatoriosStatefulScroll> {
  void refresh() {
    setState(() {});
  }

  bool showConfirmationAlert(
      BuildContext context, String title, String content) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop(false);
        return false;
      },
    );
    Widget confirmaButton = FlatButton(
      child: Text("Confimar"),
      onPressed: () {
        Navigator.of(context).pop(true);
        return true;
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelaButton,
        confirmaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: FutureBuilder(
                future: _getAnimais(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Animais>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      children = <Widget>[
                        Expanded(
                          child: Container(
                              child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return new GestureDetector(
                                  onTap: () {
                                    createDialogToGenerateReport(
                                        context, snapshot.data[index]);
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      height: 100.0,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 2, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Código do Animal: ${snapshot.data[index].codidentificacao} - ${snapshot.data[index].identificacao}",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 2, 0, 2),
                                                    child: Container(
                                                      child: Text(
                                                        "Raça: " +
                                                            snapshot.data[index]
                                                                .raca,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 2, 0, 2),
                                                    child: Container(
                                                      child: Text(
                                                        "Categoria: " +
                                                            snapshot.data[index]
                                                                .categoria,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 2, 0, 2),
                                                      child: Container(
                                                        child: Text("Peso: " +
                                                            snapshot.data[index]
                                                                .pesoentrada +
                                                            " kg"),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          )),
                        )
                      ];
                    }
                  } else if (snapshot.hasError) {
                    children = <Widget>[];
                  } else {
                    children = <Widget>[];
                  }
                  return Column(children: children);
                })),
        // SizedBox(height: 5),
        // ButtonTheme(
        //   minWidth: 300,
        //   height: 40,
        //   child: RaisedButton(
        //     onPressed: () {
        //       this._navigateToAnimais(context);
        //     },
        //     color: Colors.deepPurpleAccent,
        //     child: const Text('NOVO', style: TextStyle(fontSize: 20)),
        //   ),
        // ),
      ],
    );
  }

  createDialogToGenerateReport(BuildContext context, Animais animal) async {
    var newCategoria = TextEditingController();

    Widget noButton = FlatButton(
        child: Text("Não"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    Widget yesButton = FlatButton(
        child: Text("Sim"),
        onPressed: () {
          createExcel(animal);
          Navigator.of(context).pop();
        });

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Relatório"),
              content: Text(
                  "Você quer gerar um relatório das pesagens deste animal?"),
              actions: [noButton, yesButton],
            );
          });
        }).then((value) => setState(() {}));
  }

  static Future<List<Animais>> _getAnimais() async {
    return await DBProvider.db.getAllAnimais();
  }

  createExcel(Animais animal) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    List<Pesagens> pesagens =
        await DBProvider.db.getPesagensAnimalUuid(animal.uuid);

    sheetWrite(sheet, "B2", "Identificação:");
    sheetWrite(
        sheet, "C2", "${animal.identificacao}-${animal.codidentificacao}");
    sheetWrite(sheet, "B3", "Sexo:");
    sheetWrite(sheet, "C3", "${animal.sexo}");
    sheetWrite(sheet, "B4", "Idade(Dias):");
    sheetWrite(sheet, "C4", "${animal.idade.toString()}");
    sheetWrite(sheet, "B5", "Categoria:");
    sheetWrite(sheet, "C5", "${animal.categoria}");
    sheetWrite(sheet, "B6", "Raça:");
    sheetWrite(sheet, "C6", "${animal.raca}");

    sheetWrite(sheet, "B8", "Quantidade");
    sheetWrite(sheet, "C8", "Peso (kg)");
    sheetWrite(sheet, "D8", "Peso médio (kg)");
    sheetWrite(sheet, "E8", "Data da Pesagem");

    var index = 9;
    for (var item in pesagens) {
      sheetWrite(sheet, "A$index", "Pesagem ${index - 8}:");
      sheetWrite(sheet, "B$index", item.quantidade.toString());
      sheetWrite(sheet, "C$index", item.peso.toString());
      sheetWrite(sheet, "D$index", item.pesomedio.toString());
      sheetWrite(
          sheet,
          "E$index",
          DateFormat("dd-MM-yyyy HH:mm:ss")
              .format(DateTime.parse(item.datapesagem)));
      index++;
    }
    var pathStorage = await path.getExternalStorageDirectory();

    var xlsxPath = join("${pathStorage.path}", 'reports',
        '${animal.identificacao}-${animal.codidentificacao}.xlsx');
    excel.encode().then((onValue) {
      File(xlsxPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    OpenFile.open(xlsxPath);
  }

  sheetWrite(Sheet sheet, String index, String data) {
    sheet.cell(CellIndex.indexByString(index)).value = data;
  }
}
