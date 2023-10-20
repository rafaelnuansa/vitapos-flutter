import 'package:flutter/material.dart';
import 'package:vitapos/components/app_drawer.dart';
import 'package:vitapos/services/api.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final List<Map<String, dynamic>> transactionList = await Api().getTransactions();
      setState(() {
        transactions = transactionList;
      });
    } catch (e) {
      // Handle error, e.g., show a snackbar or an error message
      // print('Error fetching transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions List'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('Invoice: ${transaction['invoice']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount: ${transaction['total_amount']}'),
                  Text('Payment Method: ${transaction['payment_method']}'),
                ],
              ),
              onTap: () {
                // Handle what should happen when a transaction item is clicked
                // For example, you can navigate to a details page
                // or display more information about the selected transaction.
                // You can use Navigator to navigate to a new page.
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailPage(transaction: transaction)));
              },
            ),
          );
        },
      ),
    );
  }
}
