import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/pages/order/order.page.dart';
import 'package:services_controll_app/pages/order/order_management.page.dart';
import 'package:services_controll_app/utils/constants.dart';
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
      leading: Container(
          height: 100,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: filterImage()),
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

  filterImage() {
    if (widget.order.imageUrl == null || widget.order.imageUrl!.isEmpty) {
      return Icon(Icons.image);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: widget.order.imageUrl!,
        ),
      );
    }
  }
}
