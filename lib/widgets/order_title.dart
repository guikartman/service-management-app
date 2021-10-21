import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/pages/customer/customer.page.dart';
import 'package:services_controll_app/pages/order/order.page.dart';
import 'package:services_controll_app/pages/order/order_management.page.dart';
import 'package:services_controll_app/utils/functions_utils.dart';

class OrderTitle extends StatefulWidget {
  final Order order;

  OrderTitle({Key? key, required this.order}) : super(key: key);

  @override
  _OrderTitleState createState() => _OrderTitleState();
}

class _OrderTitleState extends State<OrderTitle> {
  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd/MM/yyyy');

    return ListTile(
      leading: filterIcon(),
      title: Text(widget.order.title),
      subtitle: Text(
          'Data de entrega: ${dateFormat.format(widget.order.deliveryDate)}'),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrderPage(order: widget.order)))
                    .then((_) => setState(() {}));
              },
              icon: Icon(Icons.edit),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {
                FunctionsUtils.showDeleteOrderDialog(
                    context,
                    Icons.delete,
                    Colors.red,
                    'Deseja deletar o serviço id ${widget.order.id}?',
                    'Ao confirma o serviço será definitivamente deletado!',
                    widget.order);
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderManagement(order: widget.order)))
            .then((_) => setState(() {}));
      },
    );
  }

  CircleAvatar filterIcon() {
    if (widget.order.status == 'COMPLETED') {
      return CircleAvatar(
        child: Icon(Icons.check_circle_outline_rounded),
        backgroundColor: Colors.green,
      );
    } else if (widget.order.status == 'OPEN' &&
        widget.order.deliveryDate.isBefore(DateTime.now())) {
      return CircleAvatar(
        child: Icon(
          Icons.access_time_filled,
        ),
        backgroundColor: Colors.red,
      );
    } else if (widget.order.status == 'OPEN' &&
        (widget.order.startDate.isAfter(DateTime.now()))) {
      return CircleAvatar(
        child: Icon(Icons.home_repair_service),
        backgroundColor: Colors.blueGrey,
      );
    }
    return CircleAvatar(
      child: Icon(Icons.home_repair_service),
    );
  }
}
