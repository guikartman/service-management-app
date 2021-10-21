import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/services/order.service.dart';

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
          child: Column(
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
              Text('Descrição: ${widget.order.description}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              SizedBox(
                height: 15,
              ),
              Text(
                  'Data de ínicio: ${dateFormater.format(widget.order.startDate)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              SizedBox(
                height: 15,
              ),
              Text(
                  'Data de entrega: ${dateFormater.format(widget.order.deliveryDate)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              SizedBox(
                height: 15,
              ),
              Text('Preço: R\$ ${numberFormater.format(widget.order.price)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              SizedBox(
                height: 15,
              ),
              Text('Serviço pago? ${(widget.order.isPayed) ? 'SIM' : 'NÃO'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              SizedBox(height: 15),
              Text('Cliente: ${widget.order.customer.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              SizedBox(height: 15),
              Text(
                  'Status: Serviço ${(widget.order.status == 'OPEN') ? 'Aberto' : 'Completo'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
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
                      if (widget.order.status == 'COMPLETED') {
                        orderService.updateStatus(
                            context, widget.order, 'OPEN');
                      } else {
                        orderService.updateStatus(
                            context, widget.order, 'COMPLETED');
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
