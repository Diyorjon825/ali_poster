class Report {
  double orderTotal;
  double profit;
  DateTime date;

  Report({
    required this.orderTotal,
    required this.profit,
    required this.date,
  });

  factory Report.fromJson(Map json) => Report(
        orderTotal: json['orderTotal'],
        profit: json['profit'],
        date: DateTime.parse(json['date']),
      );

  Map toJson(Report report) => {
        "orderTotal": orderTotal,
        "profit": profit,
        "date": date,
      };
}
