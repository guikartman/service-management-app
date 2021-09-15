import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:services_controll_app/models/user.model.dart';
import 'package:services_controll_app/pages/user/update_user.page.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:services_controll_app/widgets/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UserPage extends StatelessWidget {
  var user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PERFIL'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => UpdateUserPage(user: user)));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      drawer: Menu(),
      body: FutureBuilder<User>(
        future: getUser(),
        builder: (_, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );

          this.user = snapshot.data!;
          return Center(
            child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 80,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      user.email,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      user.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

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
}
