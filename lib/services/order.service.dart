import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/models/report.model.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

class OrderService {
  Future<List<Order>> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/orders?email=$email';
    var response = await http.get(Uri.parse(url), headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json; charset=UTF-8'
    });
    if (response.statusCode == 200) {
      List<Order> orders = ordersFromJson(response.body);
      return orders;
    } else {
      return List.empty();
    }
  }

  Future<Report> getReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/orders/reports?email=$email';
    var response = await http.get(Uri.parse(url), headers: <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json; charset=UTF-8'
    });
    var report;
    if (response.statusCode == 200) {
      try {
        report = reportFromJson(response.body);
      } catch (exception) {
        report = Report(
            totalCash: 0.0,
            totalCashEarned: 0.0,
            totalOrder: 0,
            totalOrderCompleted: 0,
            totalOrderDelayed: 0,
            totalOrderInProgress: 0,
            totalOrderOpen: 0);
      }
    }
    return report;
  }

  Future createNewOrder(BuildContext context, Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/orders?email=$email';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(order.toJson()));

    Navigator.of(context).pop();
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Serviço salvo com sucesso!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error ao salvar serviço!"),
      ));
    }
  }

  Future updateOrder(BuildContext context, Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final url = '${Constants.hostname}/orders';
    final response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(order.toJson()));

    Navigator.of(context).pop();
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Serviço atualizado com sucesso!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error ao salvar serviço!"),
      ));
    }
  }

  Future deleteOrder(BuildContext context, Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final url = '${Constants.hostname}/orders/${order.id}';
    final response = await http.delete(Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    Navigator.of(context).pushNamed('/');
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Serviço deletado com sucesso!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error ao deletar serviço!"),
      ));
    }
  }

  Future updateStatus(BuildContext context, Order order, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final url =
        '${Constants.hostname}/orders/${order.id}?status=${status.toString()}';
    final response = await http.patch(Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    Navigator.of(context).pushNamed('/');
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Serviço ${(status == 'COMPLETED') ? 'completo' : 'aberto'} com sucesso!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Error ao ${(status == 'COMPLETED') ? 'completar' : 'abrir'} serviço!"),
      ));
    }
  }

  Future updatePayedSatus(BuildContext context, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final url = '${Constants.hostname}/orders/payed-status/$id';
    final response = await http.patch(Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    Navigator.of(context).pushNamed('/');
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Status de pagamento do serviço atualizado com sucesso!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error ao atualizar status de pagamento do serviço!"),
      ));
    }
  }
}
