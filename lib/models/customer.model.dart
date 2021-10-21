import 'cellphone.model.dart';

class Customer {
  Customer({
    this.id,
    required this.email,
    required this.name,
    required this.cellphone,
  });

  int? id;
  String email;
  String name;
  Cellphone cellphone;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      cellphone: Cellphone.fromJson(json["cellphone"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "cellphone": cellphone,
      };

  bool operator ==(dynamic other) =>
      other != null && other is Customer && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
