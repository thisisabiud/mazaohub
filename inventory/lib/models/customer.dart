class Customer {
  String name;
  String email;
  String phone_number;

  Customer(
      {required this.email, required this.name, required this.phone_number});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        email: json['email'],
        name: json['name'],
        phone_number: json['phone_number']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email' : email,
      'phone_number' : phone_number
    };
  }
}
