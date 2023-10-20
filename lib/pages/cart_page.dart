import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/pages/charge_page.dart';
import 'package:vitapos/provider/cart_notifier.dart';
import 'package:vitapos/models/cart.dart';
import 'package:vitapos/services/api.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CartPage> createState() => CartPageState();
}

class CartPageState extends ConsumerState<CartPage> {
  double discountPercentage = 0.0;
  Api api = Api();

  @override
  void initState() {
    super.initState();
  }

  void _clearAllCart(BuildContext context) {
    ref.read(cartProvider.notifier).clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All items removed from the cart.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline), // Tombol "Clear All Cart"
            onPressed: () {
              _clearAllCart(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Daftar item keranjang
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                final product = cartItem.product;
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Konten item keranjang
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _showUpdateQuantityDialog(context, cartItem);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 14.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              InkWell(
                                onTap: () {
                                  _removeItemFromCart(cartItem);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'Price: \$${product.price.toStringAsFixed(2)} x ${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        'Subtotal: \$${cartItem.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              _checkout(context, cart);
            },
            child: Text(
              'CHARGE \$${_calculateTotalWithDiscount(cart).toStringAsFixed(2)}',
            ),
          ),
        ),
      ),
    );
  }

  void _checkout(BuildContext context, Cart cart) {
    if (cart.items.isEmpty) {
      // Tampilkan pesan kesalahan jika keranjang belanja kosong.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shopping cart is empty. Please add items first.'),
        ),
      );
    } else {
      // Navigasi ke halaman pembayaran hanya jika keranjang tidak kosong.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChargePage(
            cart: cart,
          ),
        ),
      );
    }
  }

  void _showUpdateQuantityDialog(BuildContext context, CartItem cartItem) {
    int newQuantity = cartItem.quantity;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Qty ${cartItem.product.name}',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (newQuantity > 1) {
                            setState(() {
                              newQuantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '$newQuantity',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            newQuantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  FilledButton(
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .updateItemQuantity(cartItem, newQuantity);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Update Quantity'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _removeItemFromCart(CartItem cartItem) {
    ref.watch(cartProvider.notifier).removeItemFromCart(cartItem);
  }

Decimal _calculateTotalWithDiscount(Cart cart) {
  final totalWithoutDiscount = Decimal.parse(cart.total.toStringAsFixed(2));
  final discountAmount = totalWithoutDiscount * Decimal.parse((discountPercentage / 100).toStringAsFixed(2));
  final totalWithDiscount = totalWithoutDiscount - discountAmount;
  return totalWithDiscount;
}

}
