import 'dart:ui';
import 'package:appmcpabovino/pages/subpages/animaisScroll.dart'
    as AnimaisScroll;
import 'package:appmcpabovino/pages/subpages/pesagensScroll.dart'
    as PesagemScroll;
import 'package:appmcpabovino/pages/subpages/configuracoes.dart'
    as Configuracoes;
import 'package:appmcpabovino/pages/subpages/relatoriosScroll.dart'
    as Relatorios;
import 'package:flutter/material.dart';
import '../../Database/model/Animais.dart';

// class MenuPage extends StatefulWidget {
//   @override
//   _MenuPageState createState() => _MenuPageState();
// }

class MenuPage extends StatefulWidget {
  var animal = new Animais();

  @override
  State<StatefulWidget> createState() {
    return _MenuPage();
  }
}

class _MenuPage extends State<MenuPage> {
  Future navigateToAnimais(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AnimaisScroll.AnimaisScroll()));
  }

  Future navigateToPesagem(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PesagemScroll.PesagensScroll(
                  animal: new Animais(uuid: ""),
                )));
  }

  Future navigateToConfig(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Configuracoes.Configuracoes()));
  }

  Future navigateToRelatorios(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Relatorios.Relatorios()));
  }

  var animaisCardColor = Colors.deepPurpleAccent.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new Container(),
          title: Text('AppMCPA - Bovinos'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[menu()],
              ),
            ),
          ),
        ));
  }

  Widget menu() {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            this.navigateToAnimais(context);
          },
          child: Card(
            color: animaisCardColor,
            child: Container(
                height: 80,
                width: 400,
                padding: EdgeInsets.all(2.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 3, 0, 0),
                          child: Image.asset(
                            "assets/images/vacaporco.png",
                            fit: BoxFit.fill,
                            height: 68,
                            width: 68,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 34, 0, 0),
                          child: Text("ANIMAIS",
                              style: TextStyle(
                                fontSize: 36,
                                height: 0,
                              )),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
        GestureDetector(
          onTap: () {
            this.navigateToPesagem(context);
          },
          child: Card(
            color: animaisCardColor,
            child: Container(
                height: 80,
                width: 400,
                padding: EdgeInsets.all(2.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 3, 0, 0),
                          child: Image.asset(
                            "assets/images/balanca.png",
                            fit: BoxFit.fill,
                            height: 68,
                            width: 68,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 34, 0, 0),
                          child: Text("PESAGEM",
                              style: TextStyle(
                                fontSize: 36,
                                height: 0,
                              )),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
        GestureDetector(
          onTap: () {
            this.navigateToRelatorios(context);
          },
          child: Card(
            color: animaisCardColor,
            child: Container(
                height: 80,
                width: 400,
                padding: EdgeInsets.all(2.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 3, 0, 0),
                          child: Image.asset(
                            "assets/images/report.png",
                            fit: BoxFit.fill,
                            height: 68,
                            width: 54,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 34, 0, 0),
                          child: Text("RELATÓRIOS",
                              style: TextStyle(
                                fontSize: 36,
                                height: 0,
                              )),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
        GestureDetector(
          onTap: () {
            this.navigateToConfig(context);
          },
          child: Card(
            color: animaisCardColor,
            child: Container(
                height: 80,
                width: 400,
                padding: EdgeInsets.all(2.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 3, 0, 0),
                          child: Image.asset(
                            "assets/images/configuracao.png",
                            fit: BoxFit.fill,
                            height: 68,
                            width: 68,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 24, 0, 0),
                          child: Text("CONFIGURAÇÕES",
                              style: TextStyle(
                                fontSize: 26,
                                height: 0,
                              )),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }
}
