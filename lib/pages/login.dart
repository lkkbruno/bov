import 'dart:ui';
import 'package:appmcpabovino/Database/model/Comandos.dart';
import 'package:appmcpabovino/Database/model/Login.dart';
import 'package:flutter/material.dart';
import 'package:mask_shifter/mask_shifter.dart';
import 'package:postgres/postgres.dart';

import 'home/menupage.dart';
import 'package:appmcpabovino/Database/Database.dart';

import '../Data/GlobalAssets.dart' as globals;
import '../Data/LoginAPI.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future initializePostgres() async {
    try {
      final connection = new PostgreSQLConnection(globals.connection.host,
          globals.connection.port, globals.connection.databaseName,
          username: globals.connection.username,
          password: globals.connection.password);
      await connection.open();
      await connection.transaction((trans) async {
        List<Comandos> commands = await DBProvider.db.getComandosNotExecuted();
        if (commands.length > 0) {
          commands.forEach((element) {
            globals.connection.query(element.command);
            element.executed = true;
            DBProvider.db.updateCommand(element);
          });
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final cpfController = TextEditingController();
    final password = TextEditingController();

    Future navigateToMenuPage(context) async {
      List<Login> user = await DBProvider.db.getAllLogin();

      if (user.length == 0) {
        DBProvider.db.addLogin(new Login(currentSession: cpfController.text));
      } else {
        DBProvider.db.updateLogin(
            new Login(currentSession: cpfController.text, id: user[0].id));
      }

      globals.cpf = cpfController.text;

      // var cpfClear = cpfController.text.replaceAll('.', '');
      // cpfClear = cpfClear.replaceAll('-', '');

      //bool valid = await LoginAPI().getLogin(cpfClear, password.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MenuPage()));
      // if (valid) {
      // } else {
      //   globals.showAlertDialogOK(context, "Erro", "Credenciais incorretas!");
      // }
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/loginImage.jpg"),
                fit: BoxFit.fill,
                colorFilter: new ColorFilter.mode(
                    Color.fromRGBO(255, 255, 255, 0.7), BlendMode.dstATop)),
          ),
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    controller: cpfController,
                    inputFormatters: [
                      MaskedTextInputFormatterShifter(
                          maskONE: "XXX.XXX.XXX-XX", maskTWO: "XXX.XXX.XXX-XX")
                    ],
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: new TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 2.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 2.5),
                      ),
                    )),
                Divider(),
                TextFormField(
                    obscureText: true,
                    controller: password,
                    autofocus: true,
                    style: new TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 2.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, width: 2.5),
                      ),
                    )),
                Divider(),
                ButtonTheme(
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      navigateToMenuPage(context);
                    },
                    child: Text('ENTRAR'),
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
