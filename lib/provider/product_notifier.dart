// ignore_for_file: avoid_print

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/models/product.dart';
import 'package:vitapos/services/api.dart';

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier() : super(const AsyncValue.loading());
  Api api = Api();
  Future<void> fetchProducts() async {
    try {
      final response = await api.fetchProducts();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> productsData = response['data']['data'];
        final List<Product> productList = productsData.map((productData) {
          return Product(
            id: productData['id'],
            name: productData['name'],
            code: productData['code'],
            barcode: productData['barcode'],
            description: productData['description'],
            price: Decimal.parse(productData['price'].toString()),
            cost: Decimal.parse(productData['cost'].toString()),
            image: productData['image'],
            stock: productData['stock'],
            createdAt: DateTime.parse(productData['created_at']),
            updatedAt: DateTime.parse(productData['updated_at']),
            category: productData['category']['name'],
          );
        }).toList();

        state = AsyncValue.data(productList);
      } else {}
    } catch (error) {
      print(error);
    }
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>(
  (ref) {
    return ProductNotifier();
  },
);
