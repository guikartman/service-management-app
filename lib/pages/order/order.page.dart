import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:services_controll_app/models/customer.model.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/services/customer.service.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:services_controll_app/utils/currency_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  OrderPage({this.order});

  final Order? order;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final dateFormat = DateFormat('dd/MM/yyyy');
  final numberFormat = NumberFormat.currency(locale: 'pt_BR', symbol: '');
  late Map<String, dynamic> _data;

  late List<Customer> _customers;
  late bool _isPayed;
  late DateTime _startDate;
  late DateTime _deliveryDate;

  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    if (widget.order != null) {
      _data = widget.order!.toJson();
      _isPayed = _data["isPayed"];
      _startDate = dateFormat.parse(_data["startDate"]);
      _deliveryDate = dateFormat.parse(_data["deliveryDate"]);
    } else {
      _data = Map<String, dynamic>();
      _isPayed = false;
      _startDate = DateTime.now();
      _deliveryDate = DateTime.now();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDropdownData();
  }

  void _loadDropdownData() async {
    var customerService = CustomerService();
    var customers = await customerService.getCustomers();

    if (!mounted) return;

    setState(() {
      _customers = customers;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomerService customerService = CustomerService();
    OrderService orderService = OrderService();
    return Scaffold(
        appBar: AppBar(
          title: (widget.order != null)
              ? const Text('Editar Servi??o')
              : const Text('Cadastrar Servi??o'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (!_formkey.currentState!.validate()) return;
                  _formkey.currentState!.save();
                  _data['isPayed'] = _isPayed;
                  _data['deliveryDate'] = _deliveryDate;
                  _data['startDate'] = _startDate;
                  var order = retriveOrderModel();
                  setState(() {
                    _isSaving = true;
                  });
                  if (order.id == null) {
                    orderService.createNewOrder(context, order);
                  } else {
                    orderService.updateOrder(context, order);
                  }
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: FutureBuilder<List<Customer>>(
            future: customerService.getCustomers(),
            builder: (_, AsyncSnapshot<List<Customer>> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (snapshot.hasError)
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              this._customers = snapshot.data!;
              return _isSaving
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Form(
                      key: _formkey,
                      onWillPop: () {
                        if (_hasChanges) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Existem altera????es n??o salvas'),
                                  content: const Text(
                                      'Deseja descartar as altera????es?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Sim')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('N??o'))
                                  ],
                                );
                              });
                          return Future.value(false);
                        }

                        return Future.value(true);
                      },
                      onChanged: () => _hasChanges = true,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          children: [
                            TextFormField(
                              initialValue: (_data.containsKey('title'))
                                  ? _data['title']
                                  : '',
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(labelText: 'Titulo'),
                              validator: (value) {
                                if (value!.isEmpty) return 'Campo obrigatorio.';
                              },
                              onSaved: (value) => _data['title'] = value,
                            ),
                            TextFormField(
                              initialValue: (_data.containsKey('description'))
                                  ? _data['description']
                                  : '',
                              keyboardType: TextInputType.emailAddress,
                              decoration:
                                  InputDecoration(labelText: 'Descri????o'),
                              validator: (value) {
                                if (value!.isEmpty) return 'Campo obrigatorio';
                              },
                              onSaved: (value) => _data['description'] = value,
                            ),
                            TextFormField(
                              initialValue: (_data.containsKey('price'))
                                  ? (numberFormat.format(_data['price']))
                                  : '',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Pre??o'),
                              validator: (value) {
                                if (value!.isEmpty) return 'Campo obrigatorio';
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CurrencyInputFormatter()
                              ],
                              onSaved: (value) {
                                value = value!.replaceAll('.', '');
                                value = value.replaceAll(',', '.');
                                _data['price'] = double.parse(value);
                              },
                            ),
                            DropdownButtonFormField(
                              value: _data['customer'],
                              decoration: InputDecoration(labelText: 'Cliente'),
                              onChanged: (value) {
                                _hasChanges = true;
                                setState(() {
                                  _data['customer'] = value as Customer;
                                });
                              },
                              items: _customers.map(
                                (item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                },
                              ).toList(),
                              validator: (value) =>
                                  value == null ? 'Campo obrigat??rio' : null,
                              isExpanded: true,
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(
                                            const Duration(days: 365)),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 365)),
                                      ).then((value) {
                                        if (value != null) {
                                          _hasChanges = true;
                                        }
                                        setState(() {
                                          _startDate = value!;
                                        });
                                      });
                                    },
                                    child: Icon(Icons.date_range)),
                                Text('Data de In??cio: '),
                                Text(dateFormat.format(_startDate))
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(
                                            const Duration(days: 365)),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 365)),
                                      ).then((value) {
                                        if (value != null) {
                                          _hasChanges = true;
                                        }
                                        setState(() {
                                          _deliveryDate = value!;
                                        });
                                      });
                                    },
                                    child: Icon(Icons.date_range)),
                                Text('Data de Entrega: '),
                                Text(dateFormat.format(_deliveryDate))
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isPayed,
                                  onChanged: (value) {
                                    _hasChanges = true;
                                    setState(() {
                                      _isPayed = value as bool;
                                    });
                                  },
                                ),
                                const Text(
                                  'Servi??o Pago?',
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
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
                                    '${(_data['imageUrl'] == null) ? "Adicionar Imagem" : "Atualizar Imagem"}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () => getGallery(),
                                ),
                              ),
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
                                    if (!_formkey.currentState!.validate())
                                      return;
                                    _formkey.currentState!.save();
                                    _data['isPayed'] = _isPayed;
                                    _data['deliveryDate'] = _deliveryDate;
                                    _data['startDate'] = _startDate;
                                    var order = retriveOrderModel();
                                    setState(() {
                                      _isSaving = true;
                                    });
                                    if (order.id == null) {
                                      orderService.createNewOrder(
                                          context, order);
                                    } else {
                                      orderService.updateOrder(context, order);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
            }));
  }

  getGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    _uploadImage(image!);
  }

  _uploadImage(XFile image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');

    final request = http.MultipartRequest(
        'POST', Uri.parse('${Constants.hostname}/bucket'));

    request.files.add(await http.MultipartFile.fromPath("file", image.path));
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    });
    var response = await request.send();
    if (response.statusCode == 201) {
      setState(() {
        _data['imageUrl'] = response.headers['location'];
        _hasChanges = true;
      });
    }
  }

  Order retriveOrderModel() {
    return Order(
        id: _data['id'],
        title: _data['title'],
        startDate: _data['startDate'],
        deliveryDate: _data['deliveryDate'],
        description: _data['description'],
        price: _data['price'],
        isPayed: _data['isPayed'],
        status: _data['status'],
        customer: _data['customer'],
        imageUrl: _data['imageUrl']);
  }
}
