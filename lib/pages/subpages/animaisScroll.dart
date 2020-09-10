import 'dart:ui';
import 'package:appmcpabovino/Database/model/Animais.dart';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import 'package:appmcpabovino/pages/subpages/insertAnimal.dart' as insertAnimal;
import 'package:appmcpabovino/pages/subpages/pesagensScroll.dart'
    as scrollPesagens;
import 'package:easy_alert/easy_alert.dart';

class AnimaisScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ANIMAIS"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: AnimaisStatefulScroll(),
        ));
  }
}

class AnimaisStatefulScroll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnimaisListItem();
  }
}

class AnimaisListItem extends State<AnimaisStatefulScroll> {
  void refresh() {
    setState(() {});
  }

  Future _navigateToAnimais(context) async {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => insertAnimal.InsertAnimal()))
        .then((value) => refresh());
  }

  Future _navigateToPesagens(context, Animais animal) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                scrollPesagens.PesagensScroll(animal: animal)));
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
                                    this._navigateToPesagens(
                                        context, snapshot.data[index]);
                                  },
                                  child: Dismissible(
                                    key:
                                        Key(snapshot.data[index].id.toString()),
                                    background: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      color: Colors.red,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirmação"),
                                            content: Text(
                                                "Deseja remover o animal ${snapshot.data[index].codidentificacao}?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child:
                                                      const Text("Cancelar")),
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text("Confirmar"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    onDismissed: (direction) {
                                      DBProvider.db.deleteAnimal(
                                          snapshot.data[index].id);
                                      setState(() {
                                        snapshot.data.removeAt(index);
                                      });
                                    },
                                    direction: DismissDirection.endToStart,
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
                                                              snapshot
                                                                  .data[index]
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
                                                              snapshot
                                                                  .data[index]
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
                                                              snapshot
                                                                  .data[index]
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
        SizedBox(height: 5),
        ButtonTheme(
          minWidth: 300,
          height: 40,
          child: RaisedButton(
            onPressed: () {
              this._navigateToAnimais(context);
            },
            color: Colors.deepPurpleAccent,
            child: const Text('NOVO', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }

  static Future<List<Animais>> _getAnimais() async {
    return await DBProvider.db.getAllAnimais();
  }
}
