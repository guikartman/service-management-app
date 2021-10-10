import 'package:flutter/material.dart';
import 'package:services_controll_app/models/cellphone.model.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:services_controll_app/services/customer.service.dart';

class CustomerPage extends StatefulWidget {
  CustomerPage({this.customer});

  final Customer? customer;

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late Map<String, dynamic> _data;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late bool _isWhatsapp;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _data = widget.customer!.toJson();
      _isWhatsapp = _data['cellphone'].isWhatsapp;
    } else {
      _data = Map<String, dynamic>();
      _data['cellphone'] = Cellphone();
      _isWhatsapp = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerService customerService = CustomerService();
    return Scaffold(
        appBar: AppBar(
          title: (widget.customer != null)
              ? const Text('Editar Cliente')
              : const Text('Cadastrar Cliente'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (!_formkey.currentState!.validate()) return;
                  _formkey.currentState!.save();
                  _data['cellphone'].isWhatsapp = _isWhatsapp;
                  var customer = retriveCustomerModel();
                  if (customer.id == null) {
                    customerService.createNewCustomer(context, customer);
                  } else {
                    customerService.updateCustomer(context, customer);
                  }
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
                  initialValue:
                      (_data.containsKey('name')) ? _data['name'] : '',
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio.';
                  },
                  onSaved: (value) => _data['name'] = value,
                ),
                TextFormField(
                  initialValue:
                      (_data.containsKey('email')) ? _data['email'] : '',
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
                  initialValue: (_data['cellphone'].ddd != null)
                      ? _data['cellphone'].ddd.toString()
                      : '',
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
                  onSaved: (value) {
                    _data['cellphone'].ddd = int.parse(value!);
                  },
                ),
                TextFormField(
                  initialValue: (_data['cellphone'].cellphoneNumber != null)
                      ? _data['cellphone'].cellphoneNumber.toString()
                      : '',
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Número Celular'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    if (value.length < 8 || value.length > 9)
                      return 'Número de celular inválido.';
                    if (int.tryParse(value) == null)
                      return 'Somente números são aceitos.';
                  },
                  onSaved: (value) {
                    _data['cellphone'].cellphoneNumber = int.parse(value!);
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isWhatsapp,
                      onChanged: (value) {
                        setState(() {
                          _isWhatsapp = value as bool;
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
                        _data['cellphone'].isWhatsapp = _isWhatsapp;
                        var customer = retriveCustomerModel();
                        if (customer.id == null) {
                          customerService.createNewCustomer(context, customer);
                        } else {
                          customerService.updateCustomer(context, customer);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Customer retriveCustomerModel() {
    return Customer(
        id: _data['id'],
        email: _data['email'],
        name: _data['name'],
        cellphone: _data['cellphone']);
  }
}
