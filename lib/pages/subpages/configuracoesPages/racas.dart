import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import 'package:appmcpabovino/Database/model/Racas.dart' as RacasModel;

class Racas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RacasItem();
}

class RacasItem extends State<Racas> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RAÇAS"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder(
          future: _getRacas(),
          builder: (BuildContext context,
              AsyncSnapshot<List<RacasModel.Racas>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                children = <Widget>[
                  Expanded(
                    child: Container(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final raca = snapshot.data[index].raca;
                              return CheckboxListTile(
                                  title: Text(raca),
                                  key: Key(raca),
                                  onChanged: (value) {
                                    DBProvider.db.updateRacaCheck(
                                        snapshot.data[index].id, value);
                                    setState(() {
                                      value = snapshot.data[index].checked;
                                    });
                                  },
                                  value: snapshot.data[index].checked);
                            })),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            createDialogToInsert(context).then((value) => setState(() {}));
          },
          child: Icon(Icons.add)),
    );
  }

  createDialogToInsert(BuildContext context) async {
    var newRaca = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Raça"),
              content: TextField(
                autofocus: true,
                controller: newRaca,
              ),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    child: Text("Inserir"),
                    onPressed: () {
                      if (newRaca.text != null && newRaca.text != "") {
                        DBProvider.db.addRaca(new RacasModel.Racas(
                            raca: newRaca.text, checked: false));
                        Navigator.of(context).pop();
                      }
                    })
              ],
            );
          });
        }).then((value) => setState(() {}));
  }

  static Future<List<RacasModel.Racas>> _getRacas() async {
    return await DBProvider.db.getAllRacas();
  }
}
