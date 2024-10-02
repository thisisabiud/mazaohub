import 'dart:core';

class User {
  String name;
  String reference_no;
  String email;
  String phone;
  String password;
  String address;

  User({
    required this.name,
    required this.reference_no,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "reference_no": reference_no,
        "address": address,
        "email": email,
        "phone": phone,
        "register_as": "D",
        "password": password,
      };
}
