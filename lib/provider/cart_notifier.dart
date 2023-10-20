import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/models/cart.dart';

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart(items: []));

  void addItemToCart(CartItem item) {
    final existingItemIndex = state.items.indexWhere(
      (cartItem) => cartItem.product.id == item.product.id,
    );

    if (existingItemIndex != -1) {
      // If the product is already in the cart, increase its quantity
      final updatedItem = CartItem(
        product: item.product,
        quantity: state.items[existingItemIndex].quantity + item.quantity,
      );

      state = state.copyWith(
        items: List.of(state.items)..[existingItemIndex] = updatedItem,
      );
    } else {
      // If the product is not in the cart, add it as a new item
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItemFromCart(CartItem item) {
    final updatedItems = state.items
        .where((cartItem) => cartItem.product.id != item.product.id)
        .toList();
    state = state.copyWith(items: updatedItems);
  }

  void clearCart() {
    state = Cart(items: []);
  }

  Decimal calculateTotalInCart() {
    Decimal total = Decimal.zero;

    for (var item in state.items) {
      final itemPrice = item.product.price;
      final itemQuantity = Decimal.fromInt(item.quantity);
      final itemTotal = itemPrice * itemQuantity;
      total += itemTotal;
    }

    return total;
  }

  int getProductCountInCart(int productId) {
  return state.items
      .where((cartItem) => cartItem.product.id == productId)
      .fold<int>(0, (previousValue, cartItem) => previousValue + cartItem.quantity);
}


  void updateItemQuantity(CartItem item, int newQuantity) {
    final updatedItems = state.items.map((cartItem) {
      if (cartItem.product.id == item.product.id) {
        return CartItem(
          product: item.product,
          quantity: newQuantity,
        );
      } else {
        return cartItem;
      }
    }).toList();

    state = state.copyWith(items: updatedItems);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});
