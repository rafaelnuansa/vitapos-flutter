import 'package:decimal/decimal.dart';
import 'package:vitapos/models/held_transaction.dart';
import 'package:vitapos/models/product.dart';

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  Cart copyWith({List<CartItem>? items}) {
    return Cart(
      items: items ?? this.items,
    );
  }

 Decimal get total {
    return items.fold(Decimal.zero, (total, item) => total + item.subtotal);
  }

  List<HeldTransaction> heldTransactions = [];

  void clear() {
    items.clear();
  }


  // Dalam kelas Cart atau CartNotifier
Decimal calculateTotalInCart() {
  Decimal total = Decimal.zero;
  for (var item in items) {
    Decimal itemTotal = item.product.price * Decimal.fromInt(item.quantity);
    total += itemTotal;
  }
  return total;
}

}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  Decimal get subtotal {
    return product.price * Decimal.fromInt(quantity);
  }
}

