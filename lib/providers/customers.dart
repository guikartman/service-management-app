import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:http/http.dart' as http;
import 'package:services_controll_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Customer> customerModelFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

class Customers with ChangeNotifier {
  Future<List<Customer>> get getCustomers async {
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
}
