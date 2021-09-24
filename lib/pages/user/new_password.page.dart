import 'package:flutter/material.dart';
import 'package:services_controll_app/providers/user.service.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key}) : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Novo Cliente"),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Senha atual'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio.';
                  },
                  onSaved: (value) => _data['oldPass'] = value,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Nova Senha'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio.';
                    if (value.length < 8)
                      return 'A senha precisa conter no mínimo 8 caracteres.';
                  },
                  onSaved: (value) => _data['newPass'] = value,
                ),
                TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration:
                        InputDecoration(labelText: 'Confirmar Nova Senha'),
                    validator: (value) {
                      if (value!.isEmpty) return 'Campo obrigatorio.';
                      if (value != _data['newPass'])
                        return 'As senhas não são iguais.';
                    }),
                SizedBox(height: 15),
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
                        "Salvar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        _formKey.currentState!.save();
                        if (!_formKey.currentState!.validate()) return;
                        userService.changePassword(
                            context, _data['oldPass'], _data['newPass']);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
