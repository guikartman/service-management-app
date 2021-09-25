import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:http/http.dart' as http;
import 'package:services_controll_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Customer> customerModelFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

class CustomerService {
  Future<List<Customer>> getCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/customers?email=$email';
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return customerModelFromJson(response.body);
    } else {
      return List.empty();
    }
  }

  Future createNewCustomer(BuildContext context, Customer newCustomer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/customers?email=$email';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(newCustomer.toJson()));

    Navigator.of(context).pop();
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Cliente salvo!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error ao salvar cliente!"),
      ));
    }
  }

  Future updateCustomer(BuildContext context, Customer customer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/customers?email=$email';
    final response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(customer.toJson()));

    Navigator.of(context).pushNamed('/clientes');
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Cliente atualizado!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error ao atualizar o cliente!"),
      ));
    }
  }

  Future deleteCustomer(BuildContext context, Customer customer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final url = '${Constants.hostname}/customers?id=${customer.id}';
    final response = await http.delete(Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    Navigator.of(context).pushNamed('/clientes');
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Cliente Deletado!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error ao deletar o cliente!"),
      ));
    }
  }
}
