import 'package:flutter/material.dart';
import 'package:services_controll_app/models/user.model.dart';
import 'package:services_controll_app/pages/user/update_user.page.dart';
import 'package:services_controll_app/services/user.service.dart';
import 'package:services_controll_app/widgets/menu.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var user;

  final UserService userService = UserService();

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
                            builder: (context) => UpdateUserPage(user: user)))
                    .then((_) => setState(() {}));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      drawer: Menu(),
      body: FutureBuilder<User>(
        future: userService.getUser(),
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
}
