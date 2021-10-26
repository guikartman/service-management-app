import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/pages/customer/customer.page.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:services_controll_app/utils/constants.dart';

class OrderManagement extends StatefulWidget {
  final Order order;

  OrderManagement({required this.order});

  @override
  _OrderManagementState createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  @override
  Widget build(BuildContext context) {
    var dateFormater = DateFormat('dd/MM/yyyy');
    var numberFormater = NumberFormat('###.00', 'en_US');
    var orderService = OrderService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Serviço'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              children: [
                Center(
                  child: Text(
                    widget.order.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: buildImage()),
                SizedBox(
                  height: 15,
                ),
                Text('Descrição: ${widget.order.description}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 15,
                ),
                Text(
                    'Data de ínicio: ${dateFormater.format(widget.order.startDate)}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 15,
                ),
                Text(
                    'Data de entrega: ${dateFormater.format(widget.order.deliveryDate)}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                SizedBox(height: 15),
                Divider(
                  color: Colors.black,
                ),
                Text('Cliente: ${widget.order.customer.name}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 15),
                Text('Email: ${widget.order.customer.email}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                SizedBox(height: 15),
                Text(
                    'Celular: (${widget.order.customer.cellphone.ddd}) ${widget.order.customer.cellphone.cellphoneNumber}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerPage(
                                      customer: widget.order.customer)))
                          .then((_) => setState(() {}));
                    },
                    icon: Icon(Icons.open_in_new),
                    label: Text('Abrir cliente')),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(height: 15),
                Text(
                    'Status: Serviço ${(widget.order.status == 'OPEN') ? 'Aberto' : 'Completo'}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 15,
                ),
                Text('Preço: R\$ ${numberFormater.format(widget.order.price)}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 15,
                ),
                Text('Serviço pago? ${(widget.order.isPayed) ? 'SIM' : 'NÃO'}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 30,
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
                        "${(widget.order.status == 'COMPLETED') ? 'Abrir' : 'Completar'} Serviço",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    '${(widget.order.status == "COMPLETED") ? "Abrir" : "Completar"} Serviço'),
                                content: Text(
                                    'Deseja mudar o status do serviço para ${(widget.order.status == "COMPLETED") ? "Aberto" : "Completo"}?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        if (widget.order.status ==
                                            'COMPLETED') {
                                          orderService.updateStatus(
                                              context, widget.order, 'OPEN');
                                        } else {
                                          orderService.updateStatus(context,
                                              widget.order, 'COMPLETED');
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Sim')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Não'))
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ])),
    );
  }

  buildImage() {
    if (widget.order.imageUrl == null || widget.order.imageUrl!.isEmpty) {
      return Center(
        child: Text('Numhuma imagem anexada'),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: '${Constants.imageGetStore}/${widget.order.imageUrl}/',
        ),
      );
    }
  }
}
