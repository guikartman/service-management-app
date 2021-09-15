import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services_controll_app/models/cellphone.model.dart';
import 'package:services_controll_app/models/new_customer.model.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:services_controll_app/utils/functions_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCustomerPage extends StatefulWidget {
  const NewCustomerPage({Key? key}) : super(key: key);

  @override
  _NewCustomerPageState createState() => _NewCustomerPageState();
}

class _NewCustomerPageState extends State<NewCustomerPage> {
  Map<String, dynamic> _data = Map<String, dynamic>();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isWhatsapp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  if (!_formkey.currentState!.validate()) return;
                  _formkey.currentState!.save();
                  var newCustomer = retriveCustomerModel();
                  createNewCustomer(context, newCustomer);
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio.';
                  },
                  onSaved: (value) => _data['nome'] = value,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    if (!value.contains('@')) return 'E-mail ínvalido.';
                    if (!value.contains('.')) return 'E-mail ínvalido.';
                    if (value.length < 11) return 'E-mail ínvalido.';
                  },
                  onSaved: (value) => _data['email'] = value,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Código DDD Celular'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    if (value.length != 2) return 'Código DDD inválido.';
                    if (int.tryParse(value) == null)
                      return 'Somente números são aceitos';
                    if (int.parse(value) < 11 || int.parse(value) > 99)
                      return 'Código DDD inválido';
                  },
                  onSaved: (value) => _data['celular-ddd'] = value,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Número Celular'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    if (value.length < 8 || value.length > 9)
                      return 'Número de celular inválido.';
                    if (int.tryParse(value) == null)
                      return 'Somente números são aceitos.';
                  },
                  onSaved: (value) => _data['celular'] = value,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isWhatsapp,
                      onChanged: (value) {
                        setState(() {
                          _isWhatsapp = value!;
                        });
                      },
                    ),
                    const Text(
                      'Whatsapp',
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
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
                        "Salvar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        if (!_formkey.currentState!.validate()) return;
                        _formkey.currentState!.save();
                        var newCustomer = retriveCustomerModel();
                        createNewCustomer(context, newCustomer);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  NewCustomer retriveCustomerModel() {
    var customer = new NewCustomer(email: _data['email'], name: _data['nome']);
    customer.cellphones.add(new Cellphone(
        ddd: int.parse(_data['celular-ddd']),
        cellphoneNumber: int.parse(_data['celular']),
        isWhatsapp: _isWhatsapp));
    return customer;
  }

  Future createNewCustomer(
      BuildContext context, NewCustomer newCustomerModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/customers?email=$email';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(newCustomerModel.toJson()));

    if (response.statusCode == 201) {
      FunctionsUtils.showMySimpleDialog(context, Icons.create, Colors.green,
              'Cliente salvo!', 'O cliente foi cadastrado com sucesso.')
          .then((value) => Navigator.of(context).pushNamed('/clientes'));
    } else {
      FunctionsUtils.showMySimpleDialog(
          context,
          Icons.error,
          Colors.red,
          'Error ao salvar cliente!',
          'Algum error ocorreu ao tentar criar um novo cliente, tente novamente mais tarde.');
    }
  }
}
