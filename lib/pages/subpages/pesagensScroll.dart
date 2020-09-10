import 'dart:ui';
import 'package:appmcpabovino/Database/model/Pesagens.dart';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import '../../Database/model/Animais.dart';
import 'package:appmcpabovino/pages/subpages/insertPesagem.dart'
    as insertPesagens;

class PesagensScroll extends StatefulWidget {
  PesagensScroll({Key key, this.animal}) : super(key: key);
  final Animais animal;
  @override
  State<StatefulWidget> createState() {
    return PesagensListItem();
  }
}

class PesagensListItem extends State<PesagensScroll> {
  void refresh() {
    setState(() {});
  }

  Future _navigateToPesagens(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => insertPesagens.InsertPesagemStateful(
                animal: widget.animal))).then((value) => refresh());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(["", null].contains(widget.animal.codidentificacao)
              ? "PESAGENS"
              : "PESAGENS - ${widget.animal.identificacao}: ${widget.animal.codidentificacao}"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: FutureBuilder(
                      future: _getPesagens(widget.animal.uuid),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Pesagens>> snapshot) {
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
                                        onTap: () {},
                                        child: Dismissible(
                                          key: Key(snapshot.data[index].id
                                              .toString()),
                                          background: Container(
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            color: Colors.red,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            DBProvider.db.deleteAnimal(
                                                snapshot.data[index].id);
                                            setState(() {
                                              snapshot.data.removeAt(index);
                                            });
                                          },
                                          direction:
                                              DismissDirection.endToStart,
                                          child: Card(
                                            elevation: 5,
                                            child: Container(
                                              height: 100.0,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: 100,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 2, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "Código da Pesagem: ${snapshot.data[index].codidentificacao} - ${snapshot.data[index].identificacao}",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 2, 0, 2),
                                                            child: Container(
                                                              child: Text(
                                                                "Quantidade: " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .quantidade,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 2, 0, 2),
                                                            child: Container(
                                                              child: Text(
                                                                "Peso: " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .peso +
                                                                    " kg",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          2,
                                                                          0,
                                                                          2),
                                                              child: Container(
                                                                child: Text("Peso médio: " +
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .pesomedio +
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
                    this._navigateToPesagens(context);
                  },
                  color: Colors.deepPurpleAccent,
                  child: const Text('NOVA PESAGEM',
                      style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ));
  }

  static Future<List<Pesagens>> _getPesagens(String uuid) async {
    return await DBProvider.db.getPesagensAnimalUuid(uuid);
  }
}
