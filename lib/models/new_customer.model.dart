// To parse this JSON data, do
//
//     final newCustomerModel = newCustomerModelFromJson(jsonString);

import 'dart:convert';

import 'cellphone.model.dart';

NewCustomer newCustomerModelFromJson(String str) =>
    NewCustomer.fromJson(json.decode(str));

String newCustomerModelToJson(NewCustomer data) => json.encode(data.toJson());

class NewCustomer {
  NewCustomer({required this.email, required this.name});
  String email;
  String name;
  final List<Cellphone> cellphones = List.empty(growable: true);

  factory NewCustomer.fromJson(Map<String, dynamic> json) => NewCustomer(
        email: json["email"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "cellphones": List<dynamic>.from(cellphones.map((x) => x.toJson())),
      };
}
