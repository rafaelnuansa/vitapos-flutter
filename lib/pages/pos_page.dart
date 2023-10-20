import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/components/app_drawer.dart';
import 'package:vitapos/models/cart.dart';
import 'package:vitapos/models/product.dart';
import 'package:vitapos/pages/cart_page.dart';
import 'package:vitapos/provider/cart_notifier.dart';
import 'package:vitapos/provider/product_notifier.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PosPage> createState() => PosPageState();
}

class PosPageState extends ConsumerState<PosPage> {
  String searchKeyword = '';
  String selectedCategory = 'All';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    ref.read(productNotifierProvider.notifier).fetchProducts();
  }

  Future<void> _refresh() async {
    await ref.read(productNotifierProvider.notifier).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.read(cartProvider);
    final AsyncValue<List<Product>> products =
        ref.watch(productNotifierProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: isSearching
            ? TextField(
                onChanged: (value) {
                  setState(() {
                    searchKeyword = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search Products',
                ),
              )
            : const Text(
                'VitaPOS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchKeyword = '';
                }
              });
            },
          ),
          // DropdownButton for category selection
          DropdownButton<String>(
            value: selectedCategory,
            items: [
              'All',
              ...getUniqueCategories(products.when(
                data: (productList) => productList,
                loading: () => [], // Return an empty list when loading
                error: (error, stackTrace) =>
                    [], // Return an empty list on error
              ))
            ].map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue ?? 'All';
              });
            },
          ),

          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                    child: Center(
                      child: Text(
                        cart.items
                            .map((item) => item.quantity)
                            .reduce((a, b) => a + b)
                            .toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: products.when(
          data: (productList) {
            final filteredProducts = productList.where((product) {
              final productNameLowerCase = product.name.toLowerCase();
              final searchKeywordLowerCase = searchKeyword.toLowerCase();
              final categoryMatches = selectedCategory == 'All' ||
                  product.category == selectedCategory;
              return productNameLowerCase.contains(searchKeywordLowerCase) &&
                  categoryMatches;
            }).toList();
            return CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          ref.read(cartProvider.notifier).addItemToCart(
                                CartItem(
                                  product: product,
                                  quantity: 1,
                                ),
                              );
                        },
                        child: Card(
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: product.image,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[100],
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.image),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: const Color.fromARGB(94, 63, 63, 63)
                                      .withOpacity(0.7),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${ref.watch(cartProvider.notifier).getProductCountInCart(product.id)}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      color: const Color.fromARGB(105, 0, 0, 0)
                                          .withOpacity(0.7),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.info),
                                      onPressed: () {
                                        _showProductDetails(product);
                                      },
                                      color: const Color.fromARGB(
                                          112, 180, 169, 169),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Consumer(
          builder: (context, ref, child) {
            return SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  _charge();
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CHARGE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product.name),
          content: Text('Price: \$${product.price.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _charge() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) {
      return 5;
    } else if (screenWidth >= 800) {
      return 4;
    } else if (screenWidth >= 500) {
      return 3;
    } else if (screenWidth >= 280) {
      return 2;
    } else {
      return 1;
    }
  }

  List<String> getUniqueCategories(List<Product> products) {
    return products.map((product) => product.category).toSet().toList();
  }
}
