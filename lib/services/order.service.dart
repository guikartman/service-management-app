import 'dart:convert';

import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

class OrderService {
  Future<List<Order>> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.get('email');
    final token = prefs.get('token');
    final url = '${Constants.hostname}/orders?email=$email';
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List<Order> orders = ordersFromJson(response.body);
      return orders;
    } else {
      return List.empty();
    }
  }
}
