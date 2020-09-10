import 'dart:ui';
import 'package:appmcpabovino/Database/model/Pesagens.dart';
import 'package:flutter/material.dart';
import 'package:appmcpabovino/Database/Database.dart';
import '../../Database/model/Animais.dart';
import 'package:appmcpabovino/pages/subpages/insertPesagem.dart'
    as insertPesagens;
import 'package:appmcpabovino/pages/subpages/configuracoesPages/categorias.dart'
    as categoria;
import 'package:appmcpabovino/pages/subpages/configuracoesPages/racas.dart'
    as racas;

class Configuracoes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConfiguracoesItem();
}

class ConfiguracoesItem extends State<Configuracoes> {
  var menus = ["Categorias", "Raças"];

  Future _navigateToCategorias(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => categoria.Categorias()));
  }

  Future _navigateToRacas(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => racas.Racas()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CONFIGURAÇÕES"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              // if (index == 0) {
              //   return SizedBox(height: 15);
              // } else {
              //   return SizedBox(height: 100);
              // }
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurpleAccent)),
                child: ListTile(
                  title: Text(
                    menus[index],
                    style: TextStyle(fontSize: 24),
                  ),
                  onTap: () {
                    if (menus[index] == "Categorias") {
                      this._navigateToCategorias(context);
                    } else if (menus[index] == "Raças") {
                      this._navigateToRacas(context);
                    }
                  },
                ),
              );
            }));
  }
}
