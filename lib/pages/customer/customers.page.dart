import 'package:flutter/material.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:services_controll_app/pages/customer/new_customer.page.dart';
import 'package:services_controll_app/providers/customer.service.dart';
import 'package:services_controll_app/widgets/customer_tile.dart';
import 'package:services_controll_app/widgets/menu.dart';

// ignore: must_be_immutable
class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  var customers;

  @override
  Widget build(BuildContext context) {
    final CustomerService customerService = CustomerService();
    return Scaffold(
        appBar: AppBar(
          title: Text("Clientes"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewCustomerPage()))
                      .then((_) => setState(() {}));
                },
                icon: Icon(Icons.add))
          ],
        ),
        drawer: Menu(),
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

              this.customers = snapshot.data!;
              return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (ctx, i) =>
                      CustomerTile(customer: customers[i]));
            }));
  }
}
