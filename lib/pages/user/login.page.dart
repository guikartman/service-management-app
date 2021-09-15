import 'package:flutter/material.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:services_controll_app/utils/functions_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          right: 40,
          left: 40,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 190,
              height: 190,
              child: Image.asset("assets/logo.jpg"),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  )),
              controller: emailController,
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              controller: passwordController,
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text("Recuperar Senha"),
                onPressed: () {
                  final String email = emailController.text;
                  showMyConfirmDialog(email, context);
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: SizedBox.expand(
                child: TextButton(
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    final email = this.emailController.text;
                    final password = this.passwordController.text;
                    logar(email, password, context);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: SizedBox.expand(
                child: TextButton(
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/cadastrar"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future logar(
      final String email, final String password, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final url = '${Constants.hostname}/oauth/token';
    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic Zmx1dHRlcjpGbGFtZW5nbw=='
    }, body: <String, String>{
      'username': email,
      'password': password,
      'grant_type': 'password'
    });
    if (response.statusCode == 200) {
      final String responseString = response.body;

      final token = getTokenByResponse(responseString);
      await prefs.setString("token", token);
      await FunctionsUtils.emailFromToken();
      Navigator.of(context).pushNamed('/');
    } else {
      FunctionsUtils.showMySimpleDialog(
          context,
          Icons.error,
          Colors.red,
          'Usuário e/ou senha incorretos.',
          'Desculpe, mas o usuário não pode ser validado!');
    }
  }

  Future<void> showMyConfirmDialog(
      final String email, BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Text("Esqueceu sua senha?",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          content: Text("Deseja gerar uma nova senha?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {
                Navigator.pop(context, 'Confirm'),
                retrievePassword(email, context)
              },
              child: const Text('Confirm'),
            )
          ],
        );
      },
    );
  }

  Future retrievePassword(final String email, BuildContext context) async {
    final url = '${Constants.hostname}/users/retrieve-password?email=$email';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 202) {
      FunctionsUtils.showMySimpleDialog(
          context,
          Icons.email,
          Colors.blue,
          "Senha nova gerada",
          "Sua senha foi gerada e encaminhada para o seu email.");
    } else {
      FunctionsUtils.showMySimpleDialog(
          context,
          Icons.error,
          Colors.red,
          "Error ao gerar senha",
          "Ocorreu um erro ao gerar sua senha, verifique seus dados e tente novamente.");
    }
  }

  String getTokenByResponse(String responseString) {
    var firstIndex = responseString.indexOf('access_token');
    var lastIndex = responseString.indexOf(',');
    var accessToken = responseString.substring(firstIndex, lastIndex);
    return accessToken
        .substring(accessToken.indexOf(':'))
        .replaceAll('"', '')
        .replaceAll(':', '');
  }
}
