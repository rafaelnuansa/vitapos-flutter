import 'package:flutter/material.dart';

class SuccessTransactionPage extends StatelessWidget {
  final String invoiceCode; // Tambahkan parameter ini

  const SuccessTransactionPage({required this.invoiceCode, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Transaction Successful!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Invoce : $invoiceCode',
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Thank you for your purchase.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Menampilkan snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Printing Invoice... $invoiceCode'), // Pesan yang akan ditampilkan
                    duration:
                        const Duration(seconds: 2), // Durasi pesan snackbar
                  ),
                );
              },
              child: const Text('Print Invoice'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigasi kembali ke halaman utama atau halaman lain yang sesuai
                Navigator.pushReplacementNamed(context, '/pos');
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
