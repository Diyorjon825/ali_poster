import 'package:aliposter_waiter/model/order.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.count,
    required this.priority,
    required this.remainder,
    required this.inSale,
    required this.productCategoryId,
    required this.productPhotos,
  });

  int id;
  String title;
  double price;
  double count;
  int priority;
  bool inSale;
  double? remainder;
  int productCategoryId;
  List<ProductPhoto> productPhotos;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        count: json["count"],
        remainder: json["remainder"],
        priority: json["priority"],
        inSale: json["inSale"],
        productCategoryId: json["productCategoryId"],
        productPhotos: List<ProductPhoto>.from((json["productPhotos"] ?? []).map<ProductPhoto>((x) => ProductPhoto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "count": count,
        "priority": priority,
        "inSale": inSale,
        "productCategoryId": productCategoryId,
        "productPhotos": List<dynamic>.from(productPhotos.map((x) => x.toJson())),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          count == other.count &&
          priority == other.priority &&
          inSale == other.inSale &&
          productCategoryId == other.productCategoryId &&
          productPhotos == other.productPhotos;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      count.hashCode ^
      priority.hashCode ^
      inSale.hashCode ^
      productCategoryId.hashCode ^
      productPhotos.hashCode;

  @override
  List<Object?> get props => [id, title, price, count, priority, inSale, productCategoryId, productPhotos];
}

class OrderOutComeItem {
  OrderOutComeItem({
    required this.id,
    required this.totalConsumeCount,
    required this.orderOutComeId,
    required this.orderOutCome,
    required this.productId,
    required this.product,
  });

  int id;
  int totalConsumeCount;
  int orderOutComeId;
  OrderOutCome orderOutCome;
  int productId;
  String product;

  factory OrderOutComeItem.fromJson(Map<String, dynamic> json) => OrderOutComeItem(
        id: json["id"],
        totalConsumeCount: json["totalConsumeCount"],
        orderOutComeId: json["orderOutComeId"],
        orderOutCome: OrderOutCome.fromJson(json["orderOutCome"]),
        productId: json["productId"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalConsumeCount": totalConsumeCount,
        "orderOutComeId": orderOutComeId,
        "orderOutCome": orderOutCome.toJson(),
        "productId": productId,
        "product": product,
      };
}

class OrderOutCome {
  OrderOutCome({
    required this.id,
    required this.created,
    required this.order,
    required this.orderId,
    required this.orderOutComeItems,
  });

  int id;
  DateTime created;
  Order order;
  int orderId;
  List<String> orderOutComeItems;

  factory OrderOutCome.fromJson(Map<String, dynamic> json) => OrderOutCome(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        order: Order.fromJson(json["order"]),
        orderId: json["orderId"],
        orderOutComeItems: List<String>.from(json["orderOutComeItems"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created.toIso8601String(),
        "order": order.toJson(),
        "orderId": orderId,
        "orderOutComeItems": List<dynamic>.from(orderOutComeItems.map((x) => x)),
      };
}

class PrinterPlace {
  PrinterPlace({
    required this.id,
    required this.printerName,
    required this.title,
  });

  int id;
  String printerName;
  String title;

  factory PrinterPlace.fromJson(Map<String, dynamic> json) => PrinterPlace(
        id: json["id"],
        printerName: json["printerName"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "printerName": printerName,
        "title": title,
      };
}

class ProductPhoto {
  ProductPhoto({
    required this.id,
    required this.productId,
    required this.photoPath,
  });

  int id;
  int productId;
  String photoPath;

  factory ProductPhoto.fromJson(Map<String, dynamic> json) => ProductPhoto(
        id: json["id"],
        productId: json["productId"],
        photoPath: json["photoPath"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "photoPath": photoPath,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductPhoto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          photoPath == other.photoPath;

  @override
  int get hashCode => id.hashCode ^ productId.hashCode ^ photoPath.hashCode;
}
