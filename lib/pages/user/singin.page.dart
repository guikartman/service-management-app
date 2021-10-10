import 'package:flutter/material.dart';
import 'package:services_controll_app/services/user.service.dart';

class SinginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("CADASTRO", textAlign: TextAlign.center),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          right: 40,
          left: 40,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        String patttern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (value!.length == 0) {
                          return "Informe o nome.";
                        } else if (!regExp.hasMatch(value)) {
                          return "O nome deve conter caracteres de a-z ou A-Z";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          )),
                      style: TextStyle(fontSize: 20),
                      controller: nameController,
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
                      validator: (value) {
                        if (!value!.contains('@')) {
                          return "O e-mail não está no formato válido.";
                        }
                        if (value.length < 11) {
                          return "E-mail ínvalido.";
                        }
                        if (!value.contains('.')) return 'E-mail ínvalido.';
                        return null;
                      },
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
                      validator: (value) {
                        if (value!.length < 8) {
                          return "A senha precisa conter no mínimo 8 caracteres.";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirmar Senha",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      validator: (value) {
                        final expected = passwordController.text;
                        if (value != expected) {
                          return "As senhas não são iguais.";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
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
                            "Cadastrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () async {
                            var res = _formkey.currentState!.validate();
                            if (res) {
                              userService.createNewUser(
                                  context,
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
