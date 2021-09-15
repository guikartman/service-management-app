import 'cellphone.model.dart';

class Customer {
  Customer({
    required this.id,
    required this.email,
    required this.name,
    required this.cellphones,
  });

  int id;
  String email;
  String name;
  List<Cellphone> cellphones;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        cellphones: List<Cellphone>.from(
            json["cellphones"].map((x) => Cellphone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "cellphones": List<dynamic>.from(cellphones.map((x) => x.toJson())),
      };
}
