import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitapos/components/app_drawer.dart';
import 'package:vitapos/provider/held_transactions_provider.dart';

class HeldTransactionsPage extends ConsumerWidget {
  const HeldTransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heldTransactions = ref.watch(heldTransactionsProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Held Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: heldTransactions.length,
        itemBuilder: (context, index) {
          final transaction = heldTransactions[index];

          return ListTile(
            title: Text('Transaction ${index + 1}'),
            subtitle: Text(
              'Hold Time: ${transaction.holdTime.toString()}',
            ),
            onTap: () {
              // Navigasi ke halaman detail transaksi di sini jika diperlukan
            },
          );
        },
      ),
    );
  }
}
