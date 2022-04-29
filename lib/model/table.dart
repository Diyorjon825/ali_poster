class TableModel {
  TableModel({
    this.workerFIO,
    required this.tableModelId,
    required this.tableTitle,
    this.hallId,
    required this.hasOrder,
    this.orderItemsCount,
    required this.isBusy,
    required this.guestCount,
    this.orderId,
    this.orderNumber,
    this.created,
    required this.total,
    this.isOpen = false,
    required this.createdByWorkerId,
  });

  String? workerFIO;
  int tableModelId;
  String tableTitle;
  int? hallId;
  String? hallTitle;
  bool hasOrder;
  int? orderItemsCount;
  bool isBusy;
  bool isOpen;
  int guestCount;
  int? orderId;
  String? orderNumber;
  DateTime? created;
  double total;
  int createdByWorkerId;

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        workerFIO: json["workerFIO"],
        tableModelId: json["tableModelId"],
        tableTitle: json["tableTitle"],
        hallId: json["hallId"],
        hasOrder: json["hasOrder"],
        orderItemsCount: json["orderItemsCount"],
        isBusy: json["isBusy"],
        guestCount: json["guestCount"],
        orderId: json["orderId"],
        orderNumber: json["orderNumber"],
        created: DateTime.parse(json["created"]),
        total: json["total"],
        createdByWorkerId: json["createdByWorkerId"],
      );

  Map<String, dynamic> toJson() => {
        "workerFIO": workerFIO,
        "tableModelId": tableModelId,
        "tableTitle": tableTitle,
        "hallId": hallId,
        "hasOrder": hasOrder,
        "orderItemsCount": orderItemsCount,
        "isBusy": isBusy,
        "guestCount": guestCount,
        "orderId": orderId,
        "orderNumber": orderNumber,
        "created": created?.toIso8601String(),
        "total": total,
        "createdByWorkerId": createdByWorkerId
      };
}

class TableState {
  TableState({
    required this.id,
    required this.isTableBussy,
    required this.tableModelId,
    required this.tableModel,
  });

  int id;
  bool isTableBussy;
  int tableModelId;
  String tableModel;

  factory TableState.fromJson(Map<String, dynamic> json) => TableState(
        id: json["id"],
        isTableBussy: json["isTableBussy"],
        tableModelId: json["tableModelId"],
        tableModel: json["tableModel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isTableBussy": isTableBussy,
        "tableModelId": tableModelId,
        "tableModel": tableModel,
      };
}
