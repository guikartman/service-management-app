import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:services_controll_app/models/customer.model.dart';
import 'package:services_controll_app/models/order.model.dart';
import 'package:services_controll_app/services/customer.service.dart';
import 'package:services_controll_app/services/order.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionsUtils {
  static Future<void> showMySimpleDialog(
      BuildContext context, String title, String content) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  static Future<void> showDeleteCustomerDialog(BuildContext context,
      String title, String content, Customer customer) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  CustomerService().deleteCustomer(context, customer);
                },
                child: const Text(
                  'Sim',
                )),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Não',
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showDeleteOrderDialog(
      BuildContext context, String title, String content, Order order) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  OrderService().deleteOrder(context, order);
                },
                child: const Text(
                  'Sim',
                )),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Não',
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> emailFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('token');
    final parts = token.toString().split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    String payload = decodeBase64(parts[1]);
    final email = getEmailFromPayload(payload);
    prefs.setString("email", email);
  }

  static String getEmailFromPayload(String payloadMap) {
    var firstIndex = payloadMap.indexOf('user_name');
    var lastIndex = payloadMap.indexOf('authorities');
    var email = payloadMap.substring(firstIndex, lastIndex);
    return email
        .substring(email.indexOf(':'))
        .replaceAll('"', '')
        .replaceAll(':', '')
        .replaceAll(',', '');
  }

  static String decodeBase64(String str) {
    //'-', '+' 62nd char of encoding,  '_', '/' 63rd char of encoding
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      // Pad with trailing '='
      case 0: // No pad chars in this case
        break;
      case 2: // Two pad chars
        output += '==';
        break;
      case 3: // One pad char
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
