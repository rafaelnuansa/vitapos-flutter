import 'package:decimal/decimal.dart';
class Product {
  final int id;
  final String name;
  final String code;
  final String barcode;
  final String description;
  final Decimal price;
  final Decimal cost;
  final String image;
  final String stock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.barcode,
    required this.description,
    required this.price,
    required this.cost,
    required this.image,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });
}
