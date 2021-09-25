class Cellphone {
  Cellphone({
    this.id,
    this.ddd,
    this.cellphoneNumber,
    this.isWhatsapp,
  });

  int? id;
  int? ddd;
  int? cellphoneNumber;
  bool? isWhatsapp;

  factory Cellphone.fromJson(Map<String, dynamic> json) => Cellphone(
        id: json["id"],
        ddd: json["ddd"],
        cellphoneNumber: json["cellphoneNumber"],
        isWhatsapp: json["isWhatsapp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ddd": ddd,
        "cellphoneNumber": cellphoneNumber,
        "isWhatsapp": isWhatsapp,
      };
}
