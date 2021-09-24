import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:services_controll_app/models/user.model.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:services_controll_app/utils/functions_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/users/$email';
    final response = await http.get(Uri.parse(url),
        headers: <String, String>{"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    throw new Exception('Failed to get the user.');
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

  Future createNewUser(
      BuildContext context, String name, String email, String password) async {
    var uri = '${Constants.hostname}/users';
    final response = await http.post(Uri.parse(uri),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password
        }));
    if (response.statusCode == 201) {
      FunctionsUtils.showMySimpleDialog(context, Icons.done, Colors.green,
              'Usuario criado com successo!', 'Valide no seu email.')
          .then((value) => Navigator.of(context).pushNamed('/login'));
    } else {
      FunctionsUtils.showMySimpleDialog(
          context,
          Icons.error,
          Colors.red,
          'Error ao criar o usuário',
          'Algum error ocorreu ao criar o usuário.');
    }
  }

  Future updateUserName(BuildContext context, String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final email = prefs.get('email');
    var uri = '${Constants.hostname}/users/$email?name=$userName';
    final response = await http.put(Uri.parse(uri),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    Navigator.of(context).build(context);
    if (response.statusCode == 202) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("O nome foi alterado!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error ao alterar o nome!"),
      ));
    }
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

  Future changePassword(
      BuildContext context, String oldPass, String newPass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final email = prefs.get('email');
    var uri =
        '${Constants.hostname}/users/$email/change-password?oldPassword=$oldPass&newPassword=$newPass';
    final response = await http.put(Uri.parse(uri),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    Navigator.of(context).pop();
    if (response.statusCode == 202) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Senha alterada com sucesso!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            "Não foi possível alterar a senha, tente novamente mais tarde!"),
      ));
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
