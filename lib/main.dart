import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appmcpabovino/pages/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppMCPA - Bovinos',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(title: 'AppMCPA - Bovinos'),
    );
  }
}