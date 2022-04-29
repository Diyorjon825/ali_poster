class Customer {
  Customer({
    required this.id,
    required this.fio,
    required this.phoneNumber,
    required this.email,
    required this.created,
    required this.customerAddresses,
  });

  int id;
  String fio;
  String phoneNumber;
  String email;
  DateTime created;
  List<CustomerAddress> customerAddresses;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        fio: json["fio"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        created: DateTime.parse(json["created"]),
        customerAddresses: List<CustomerAddress>.from(json["customerAddresses"].map((x) => CustomerAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fio": fio,
        "phoneNumber": phoneNumber,
        "email": email,
        "created": created.toIso8601String(),
        "customerAddresses": List<dynamic>.from(customerAddresses.map((x) => x.toJson())),
      };
}

class CustomerAddress {
  CustomerAddress({
    required this.id,
    required this.address,
    required this.customerId,
    required this.customer,
  });

  int id;
  String address;
  int customerId;
  String customer;

  factory CustomerAddress.fromJson(Map<String, dynamic> json) => CustomerAddress(
        id: json["id"],
        address: json["address"],
        customerId: json["customerId"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "customerId": customerId,
        "customer": customer,
      };
}
