import 'package:flutter/material.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:services_controll_app/providers/customer.service.dart';

class CustomerPage extends StatefulWidget {
  final Customer customer;

  const CustomerPage({Key? key, required this.customer}) : super(key: key);

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  bool? _isWhatsapp;

  @override
  void initState() {
    super.initState();
    _isWhatsapp = widget.customer.cellphone.isWhatsapp;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final CustomerService customerService = CustomerService();
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Cliente'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (!_formkey.currentState!.validate()) return;
                  _formkey.currentState!.save();
                  widget.customer.cellphone.isWhatsapp = _isWhatsapp!;
                  customerService.updateCustomer(context, widget.customer);
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
                  initialValue: widget.customer.name,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio.';
                  },
                  onSaved: (value) => widget.customer.name = value!,
                ),
                TextFormField(
                  initialValue: widget.customer.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    if (!value.contains('@')) return 'E-mail ínvalido.';
                    if (!value.contains('.')) return 'E-mail ínvalido.';
                    if (value.length < 11) return 'E-mail ínvalido.';
                  },
                  onSaved: (value) => widget.customer.email = value!,
                ),
                TextFormField(
                  initialValue: '${widget.customer.cellphone.ddd}',
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
                  onSaved: (value) =>
                      widget.customer.cellphone.ddd = int.parse(value!),
                ),
                TextFormField(
                  initialValue: '${widget.customer.cellphone.cellphoneNumber}',
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Número Celular'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Campo obrigatorio';
                    if (value.length < 8 || value.length > 9)
                      return 'Número de celular inválido.';
                    if (int.tryParse(value) == null)
                      return 'Somente números são aceitos.';
                  },
                  onSaved: (value) => widget
                      .customer.cellphone.cellphoneNumber = int.parse(value!),
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
                        widget.customer.cellphone.isWhatsapp = _isWhatsapp!;
                        customerService.updateCustomer(
                            context, widget.customer);
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
