class Product {
  int? id;
  final String name;
  final double price;
  final int quantity;
  final int saleId;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.saleId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        price: json['price'] as double,
        quantity: json['quantity'] as int,
        saleId: json['saleId'] as int,
      );


  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
        'saleId': saleId,
      };
}
