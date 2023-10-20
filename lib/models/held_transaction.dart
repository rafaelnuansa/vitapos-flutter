import 'package:vitapos/models/cart.dart';

class HeldTransaction {
  final String name;
  final DateTime holdTime;
  final List<CartItem> items;
  final String customer; // Tambahkan properti customer

  HeldTransaction({
    required this.name,
    required this.holdTime,
    required this.items,
    required this.customer, // Inisialisasi properti customer
  });
}
