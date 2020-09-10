library my_prj.globals;

import 'package:postgres/postgres.dart';
import 'package:flutter/material.dart';

String cpf = "";
final connection = new PostgreSQLConnection("191.234.181.93", 5432, "modulos",
    username: "postgres", password: "mlkp98!@#1982");

showAlertDialogOK(BuildContext context, String title, String content) {
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
