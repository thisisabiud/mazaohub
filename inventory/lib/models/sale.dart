import 'dart:convert';

import 'package:inventory/models/product.dart';

class Sale {
  int? id;
  final String date;
  final String description;
  List<Product> _products = [];

  Sale({
    this.id,
    required this.date,
    required this.description,
  });

  List<Product> get products => List.unmodifiable(_products);


  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      date: json['date'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'description': description,
    };
  }

  void addProduct(Product product) {
    _products.add(product);
  }

  void removeProduct(Product product) {
    _products.remove(product);
  }
}
