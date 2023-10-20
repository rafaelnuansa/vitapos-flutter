import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/components/app_drawer.dart';
import 'package:vitapos/services/api.dart';

class CustomerPage extends ConsumerWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membuat instance Api
    final api = Api();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Menggunakan metode fetchCustomers dari Api
        future: api.fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No customers available.'),
            );
          } else {
            final customers = snapshot.data!;

            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];

                // Ganti dengan tampilan item pelanggan yang sesuai dengan data Anda
                return ListTile(
                  title: Text(customer['name'].toString()),
                  subtitle: Text(customer['email'].toString()),
                  // Tambahan: Tambahkan aksi lain sesuai kebutuhan Anda
                );
              },
            );
          }
        },
      ),
    );
  }
}
