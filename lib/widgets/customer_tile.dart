import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:services_controll_app/pages/customer/customer.page.dart';
import 'package:services_controll_app/utils/functions_utils.dart';

class CustomerTile extends StatefulWidget {
  final Customer customer;

  const CustomerTile({Key? key, required this.customer}) : super(key: key);

  @override
  _CustomerTileState createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(widget.customer.name),
        subtitle: Text(widget.customer.email),
      ),
      actions: [
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerPage(customer: widget.customer)))
                .then((_) => setState(() {}));
          },
        ),
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            FunctionsUtils.showDeleateCustomerDialog(
                context,
                Icons.delete,
                Colors.red,
                'Deseja deletar o cliente Id: ${widget.customer.id}?',
                'Ao clicar no botão Sim o cliente será definitivamente deletado!',
                widget.customer);
          },
        )
      ],
    );
  }
}
