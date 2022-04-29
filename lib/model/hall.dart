import 'package:aliposter_waiter/model/table.dart';

class Hall {
  Hall({
    required this.id,
    required this.title,
    required this.percent,
    required this.tableModels,
  });

  int id;
  String title;
  double percent;
  List<TableModel> tableModels;

  factory Hall.fromJson(Map<String, dynamic> json) => Hall(
        id: json["id"],
        title: json["title"],
        percent: json["percent"],
        tableModels: List.from(json["tableModels"].map((x) => TableModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "percent": percent,
        "tableModels": List<dynamic>.from(tableModels.map((x) => x.toJson())),
      };
}
