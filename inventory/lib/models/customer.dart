class Customer {
  int? id;
  String name;
  String email;
  String TIN;
  String address;
  String phone_number;

  Customer(
      {this.id,
      required this.email,
      required this.TIN,
      required this.address,
      required this.name,
      required this.phone_number});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json['id'],
        TIN: json['TIN'],
        address: json['address'],
        email: json['email'],
        name: json['name'],
        phone_number: json['phone_number']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone_number": phone_number,
      "address": address,
      "TIN": TIN,
    };
  }
}
