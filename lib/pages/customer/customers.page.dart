import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:services_controll_app/pages/customer/new_customer.page.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:services_controll_app/widgets/customer_tile.dart';
import 'package:services_controll_app/widgets/menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<Customer> customerModelFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

// ignore: must_be_immutable
class CustomersPage extends StatelessWidget {
  var customers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("CLIENTES"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewCustomerPage()));
                },
                icon: Icon(Icons.add))
          ],
        ),
        drawer: Menu(),
        body: FutureBuilder<List<Customer>>(
            future: retrieveCustomers(),
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

  Future<List<Customer>> retrieveCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/customers?email=$email';
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return customerModelFromJson(response.body);
    }
    return List.empty();
  }
}
