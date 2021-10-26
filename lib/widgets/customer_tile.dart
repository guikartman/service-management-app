import 'package:flutter/material.dart';
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
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(widget.customer.name),
      subtitle: Text(widget.customer.email),
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
                                CustomerPage(customer: widget.customer)))
                    .then((_) => setState(() {}));
              },
              icon: Icon(Icons.edit),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {
                FunctionsUtils.showDeleteCustomerDialog(
                    context,
                    'Deseja deletar o cliente Id ${widget.customer.id}?',
                    'Ao confirmar o cliente será definitivamente deletado!',
                    widget.customer);
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
