class Customer {
  int? id;
  String name;
  String email;
  String tin;
  String address;
  String phoneNumber;

  Customer(
      {this.id,
      required this.email,
      required this.tin,
      required this.address,
      required this.name,
      required this.phoneNumber});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json['id'],
        tin: json['TIN'],
        address: json['address'],
        email: json['email'],
        name: json['name'],
        phoneNumber: json['phone_number']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "address": address,
      "TIN": tin,
    };
  }
}
