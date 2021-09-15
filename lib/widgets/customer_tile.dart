import 'package:flutter/material.dart';
import 'package:services_controll_app/models/customer.model.dart';

class CustomerTile extends StatelessWidget {
  final CustomerModel customer;

  const CustomerTile({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(customer.name),
      subtitle: Text(customer.email),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
              color: Colors.orange,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
