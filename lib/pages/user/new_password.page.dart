import 'package:flutter/material.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:services_controll_app/utils/functions_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key}) : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        changePassword(
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

  Future changePassword(
      BuildContext context, String oldPass, String newPass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final email = prefs.get('email');
    var uri =
        '${Constants.hostname}/users/$email/change-password?oldPassword=$oldPass&newPassword=$newPass';
    final response = await http.put(Uri.parse(uri),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response.statusCode == 202) {
      FunctionsUtils.showMySimpleDialog(
              context,
              Icons.done,
              Colors.green,
              'Senha alterada com sucesso!',
              'Sua senha foi alterada com sucesso.')
          .then((value) => Navigator.of(context).pop());
    } else {
      FunctionsUtils.showMySimpleDialog(
          context,
          Icons.error,
          Colors.red,
          'Error ao alterar a senha!',
          'Algum error ocorreu, verifique se a senha informada está correta.');
    }
  }
}
