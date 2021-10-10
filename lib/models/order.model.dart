import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'customer.model.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.id,
    required this.title,
    required this.startDate,
    required this.deliveryDate,
    required this.description,
    required this.price,
    required this.status,
    required this.isPayed,
    required this.customer,
  });

  int? id;
  String title;
  DateTime startDate;
  DateTime deliveryDate;
  String description;
  double price;
  String status;
  bool isPayed;
  Customer customer;

  factory Order.fromJson(Map<String, dynamic> json) {
    var dateFormat = DateFormat('dd/MM/yyyy');

    return Order(
      id: json["id"],
      title: json["title"],
      startDate: dateFormat.parse(json["startDate"]),
      deliveryDate: dateFormat.parse(json["deliveryDate"]),
      description: json["description"],
      price: json["price"].toDouble(),
      status: json["status"],
      isPayed: json["isPayed"],
      customer: Customer.fromJson(json["customer"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "startDate": startDate,
        "deliveryDate": deliveryDate,
        "description": description,
        "price": price,
        "status": status,
        "isPayed": isPayed,
        "customer": customer.toJson(),
      };
}
