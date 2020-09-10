import 'dart:ui';
import 'package:appmcpabovino/Database/model/Pesagens.dart';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import 'package:appmcpabovino/pages/subpages/insertPesagem.dart'
    as insertPesagens;
import 'package:appmcpabovino/Database/model/Categorias.dart'
    as CategoriasModel;

class Categorias extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategoriasItem();
}

class CategoriasItem extends State<Categorias> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CATEGORIAS"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder(
          future: _getCategorias(),
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoriasModel.Categorias>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                children = <Widget>[
                  Expanded(
                    child: Container(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final categoria = snapshot.data[index].categoria;
                              return CheckboxListTile(
                                  title: Text(categoria),
                                  key: Key(categoria),
                                  onChanged: (value) {
                                    DBProvider.db.updateCategoriaCheck(
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
    var newCategoria = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Categoria"),
              content: TextField(
                autofocus: true,
                controller: newCategoria,
              ),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    child: Text("Inserir"),
                    onPressed: () {
                      if (newCategoria.text != null &&
                          newCategoria.text != "") {
                        DBProvider.db.addCategoria(
                            new CategoriasModel.Categorias(
                                categoria: newCategoria.text, checked: false));
                        Navigator.of(context).pop();
                      }
                    })
              ],
            );
          });
        }).then((value) => setState(() {}));
  }

  static Future<List<CategoriasModel.Categorias>> _getCategorias() async {
    return await DBProvider.db.getAllCategorias();
  }
}
