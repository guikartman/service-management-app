import 'dart:convert';

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  Report({
    required this.totalCash,
    required this.totalCashEarned,
    required this.totalOrder,
    required this.totalOrderCompleted,
    required this.totalOrderDelayed,
    required this.totalOrderInProgress,
    required this.totalOrderOpen,
  });

  double totalCash;
  double totalCashEarned;
  int totalOrder;
  int totalOrderCompleted;
  int totalOrderDelayed;
  int totalOrderInProgress;
  int totalOrderOpen;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        totalCash: json["totalCash"],
        totalCashEarned: json["totalCashEarned"],
        totalOrder: json["totalOrder"],
        totalOrderCompleted: json["totalOrderCompleted"],
        totalOrderDelayed: json["totalOrderDelayed"],
        totalOrderInProgress: json["totalOrderInProgress"],
        totalOrderOpen: json["totalOrderOpen"],
      );

  Map<String, dynamic> toJson() => {
        "totalCash": totalCash,
        "totalCashEarned": totalCashEarned,
        "totalOrder": totalOrder,
        "totalOrderCompleted": totalOrderCompleted,
        "totalOrderDelayed": totalOrderDelayed,
        "totalOrderInProgress": totalOrderInProgress,
        "totalOrderOpen": totalOrderOpen,
      };
}
