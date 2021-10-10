import 'package:flutter/material.dart';
import 'package:services_controll_app/models/user.model.dart';
import 'package:services_controll_app/services/user.service.dart';

import 'new_password.page.dart';

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? user;

  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONFIGURAÇÃO'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _formKey.currentState!.save();
                if (!_formKey.currentState!.validate()) return;
                userService.updateUserName(context, _data['name']);
              },
              icon: Icon(Icons.save))
        ],
      ),
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

          var user = snapshot.data;
          return Form(
            key: _formKey,
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return 'Campo obrigatorio.';
                        },
                        initialValue: user?.name,
                        decoration: InputDecoration(
                            labelText: 'Nome',
                            suffixIcon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                        onSaved: (value) => _data['name'] = value,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        child: Text(
                          "Mudar Senha",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push<User>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewPasswordPage()));
                        },
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
