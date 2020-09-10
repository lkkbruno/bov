import 'package:dio/dio.dart';
import 'dart:convert';
import '../Database/model/LoginAPIModel.dart';

class LoginAPI {
  final Dio _dio = Dio();
  String url = "http://app.pamplona.com.br:8082";

  Map<String, dynamic> toJson(String encode) => {
        'Login': {'authToken': encode}
      };

  Future<bool> getLogin(String user, String password) async {
    var encoded = utf8.encode("$user:$password");
    var base64encoded = base64.encode(encoded);

    Response response = await _dio.post(
        '$url/ColetaLeitoesJavaEnvironment/rest/Login',
        data: toJson(base64encoded));

    if (response.data.toString().contains("Senha informada é inválida!") ||
        response.data.toString().contains("Usuário informado é inválido!")) {
      return false;
    } else {
      return true;
    }
  }
}
