class Warehouse {
  Warehouse({
    required this.id,
    required this.created,
    required this.lastUpdated,
    required this.count,
    required this.productId,
    required this.product,
  });

  int id;
  DateTime created;
  DateTime lastUpdated;
  int count;
  int productId;
  String product;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        lastUpdated: DateTime.parse(json["lastUpdated"]),
        count: json["count"],
        productId: json["productId"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created.toIso8601String(),
        "lastUpdated": lastUpdated.toIso8601String(),
        "count": count,
        "productId": productId,
        "product": product,
      };
}
