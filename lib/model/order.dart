import 'package:aliposter_waiter/model/product.dart';
import 'package:equatable/equatable.dart';

class Order {
  Order({
    this.id,
    this.totalCash,
    this.totalCard,
    this.total,
    this.totalDiscount,
    this.payedTotal,
    this.change,
    this.servicePercentage,
    this.workerCreateId,
    this.created,
    required this.tableModelId,
    this.discountPercent,
    this.discountAmount,
    this.orderNumber,
    required this.guestCount,
    required this.orderItems,
  });

  int? id;
  double? totalCash;
  double? totalCard;
  double? total;
  double? totalDiscount;
  double? payedTotal;
  double? change;
  double? servicePercentage;
  int? workerCreateId;
  DateTime? created;
  int tableModelId;

  // int shiftId;
  double? discountPercent;
  double? discountAmount;

  // String comment;
  String? orderNumber;
  int guestCount;
  List<OrderItem> orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        totalCash: json["totalCash"],
        totalCard: json["totalCard"],
        total: json["total"],
        totalDiscount: json["totalDiscount"],
        payedTotal: json["payedTotal"],
        change: json["change"],
        servicePercentage: json["servicePercentage"],
        workerCreateId: json["workerCreateId"],
        created: DateTime.parse(json["created"]),
        tableModelId: json["tableModelId"],
        discountPercent: json["discountPercent"],
        discountAmount: json["discountAmount"],
        orderNumber: json["orderNumber"],
        guestCount: json["guestCount"],
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalCash": totalCash,
        "totalCard": totalCard,
        "total": total,
        "totalDiscount": totalDiscount,
        "payedTotal": payedTotal,
        "change": change,
        "servicePercentage": servicePercentage,
        "workerCreateId": workerCreateId,
        "created": created?.toIso8601String(),
        "tableModelId": tableModelId,
        "discountPercent": discountPercent,
        "discountAmount": discountAmount,
        "orderNumber": orderNumber,
        "guestCount": guestCount,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class OrderItem extends Equatable {
  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.product,
    this.price,
    required this.count,
    this.total,
    this.workerId,
    this.created,
    this.workerPercent,
  });

  int? id;
  int? orderId;
  int? productId;
  double? price;
  double count;
  double? total;
  int? workerId;
  Product? product;
  DateTime? created;
  double? workerPercent;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        orderId: json["orderId"],
        productId: json["productId"],
        price: json["price"],
        count: json["count"],
        total: json["total"],
        workerId: json["workerId"],
        product: Product.fromJson(json["product"]),
        created: DateTime.parse(json["created"]),
        workerPercent: json["workerPercent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "productId": productId,
        "price": price,
        "count": count,
        "total": total,
        "workerId": workerId,
        "product": product?.toJson(),
        "created": created?.toIso8601String(),
        "workerPercent": workerPercent,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          orderId == other.orderId &&
          productId == other.productId &&
          price == other.price &&
          count == other.count &&
          total == other.total &&
          workerId == other.workerId &&
          product == other.product &&
          created == other.created &&
          workerPercent == other.workerPercent;

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      productId.hashCode ^
      price.hashCode ^
      count.hashCode ^
      total.hashCode ^
      workerId.hashCode ^
      product.hashCode ^
      created.hashCode ^
      workerPercent.hashCode;

  @override
  List<Object?> get props => [id, orderId, productId, price, count, total, workerId, product, created, workerPercent];
}
