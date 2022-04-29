import 'package:aliposter_waiter/model/product.dart';

class Category {
  Category({
    required this.id,
    required this.title,
    required this.priority,
    this.image,
    required this.products,
  });

  int id;
  String title;
  int priority;
  String? image;
  List<Product> products;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        priority: json["priority"],
        image: json["image"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "priority": priority,
        "image": image,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
