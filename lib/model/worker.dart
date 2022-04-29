class Worker {
  Worker({
    required this.id,
    required this.name,
    required this.code,
    required this.percent,
    required this.workerType,
    required this.canEditOrderOpenedNotMyself,
    required this.canRemoveOrderItem,
  });

  int id;
  String name;
  String code;
  int percent;
  int workerType;
  bool canEditOrderOpenedNotMyself;
  bool canRemoveOrderItem;

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        percent: json["percent"],
        workerType: json["workerType"],
        canEditOrderOpenedNotMyself: json["canEditOrderOpenedNotMyself"],
        canRemoveOrderItem: json["canRemoveOrderItem"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "percent": percent,
        "workerType": workerType,
        "canEditOrderOpenedNotMyself": canEditOrderOpenedNotMyself,
        "canRemoveOrderItem": canRemoveOrderItem,
      };
}
