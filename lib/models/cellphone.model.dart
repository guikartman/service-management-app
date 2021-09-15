class Cellphone {
  Cellphone({
    required this.ddd,
    required this.cellphoneNumber,
    required this.isWhatsapp,
  });

  int ddd;
  int cellphoneNumber;
  bool isWhatsapp;

  factory Cellphone.fromJson(Map<String, dynamic> json) => Cellphone(
        ddd: json["ddd"],
        cellphoneNumber: json["cellphoneNumber"],
        isWhatsapp: json["isWhatsapp"],
      );

  Map<String, dynamic> toJson() => {
        "ddd": ddd,
        "cellphoneNumber": cellphoneNumber,
        "isWhatsapp": isWhatsapp,
      };
}
