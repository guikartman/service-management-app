import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:services_controll_app/models/order.model.dart';
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

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        leading: filterIcon(),
        title: Text(widget.order.title),
        subtitle: Text(
            'Data de entrega: ${dateFormat.format(widget.order.deliveryDate)}'),
      ),
      actions: [
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            // Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>
            //                 )
            //     .then((_) => setState(() {}));
          },
        ),
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            // FunctionsUtils.showDeleateCustomerDialog(
            //     context,
            //     Icons.delete,
            //     Colors.red,
            //     'Deseja deletar o cliente Id: ${widget.customer.id}?',
            //     'Ao clicar no botão Sim o cliente será definitivamente deletado!',
            //     widget.customer);
          },
        )
      ],
    );
  }

  CircleAvatar filterIcon() {
    if (widget.order.status == 'COMPLETED') {
      return CircleAvatar(
        child: Icon(Icons.check_circle_outline_rounded),
      );
    } else if (widget.order.status == 'OPEN' &&
        widget.order.deliveryDate.isAfter(DateTime.now())) {
      return CircleAvatar(
        child: Icon(Icons.access_time_filled),
      );
    }
    return CircleAvatar(
      child: Icon(Icons.home_repair_service),
    );
  }
}
