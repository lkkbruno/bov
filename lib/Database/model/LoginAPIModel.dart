class LoginAPIModel {
  String authToken;
  String loginTipo;
  int loginRetorno;

  LoginAPIModel({this.authToken, this.loginTipo, this.loginRetorno});

  factory LoginAPIModel.fromJson(Map doc) {
    return LoginAPIModel(
        authToken: doc['authToken'],
        loginTipo: doc['Login_Tipo'],
        loginRetorno: doc['Login_Retorno']);
  }
}
