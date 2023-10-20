// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:vitapos/models/cart.dart';
import 'package:vitapos/pages/success_transaction_page.dart';
import 'package:vitapos/services/api.dart'; // Import kelas Api
import 'package:vitapos/models/transaction.dart'; // Import model Transaction

class ChargePage extends StatefulWidget {
  final Cart cart;

  const ChargePage({Key? key, required this.cart}) : super(key: key);

  @override
  ChargePageState createState() => ChargePageState();
}

class ChargePageState extends State<ChargePage> {
  String? paymentMethod = 'Cash';
  Api api = Api(); // Inisialisasi objek Api

  @override
  Widget build(BuildContext context) {
    Decimal totalAmount = Decimal.parse(widget.cart.total.toStringAsFixed(2));
    Decimal amountPaid = totalAmount;
    Decimal discountAmount =
        Decimal.zero; // Initialize discount as Decimal.zero

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Enter Amount Due:',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              controller:
                  TextEditingController(text: amountPaid.toStringAsFixed(2)),
              textAlign: TextAlign.center,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  amountPaid = Decimal.parse(value);
                } else {
                  amountPaid = Decimal.zero;
                }
              },
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Payment Method:',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: 'Cash',
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
                const Text('Cash'),
                Radio(
                  value: 'Card',
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
                const Text('Card'),
                Radio(
                  value: 'Kredit',
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
                const Text('Kredit'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () async {
              // Membuat transaksi
              final Transaction transaction = Transaction(
                customerId: null, // Adjust to the customer ID if available
                cash: amountPaid.toDouble(), // Convert Decimal to double
                change: Decimal.zero.toDouble(), // Convert Decimal to double
                discount:
                    discountAmount.toDouble(), // Convert Decimal to double
                totalAmount:
                    totalAmount.toDouble(), // Convert Decimal to double
                paymentMethod: paymentMethod!,
                remainingAmount:
                    Decimal.zero.toDouble(), // Convert Decimal to double
                status: 'Paid', // Adjust transaction status
                transactionDetails: widget.cart.items
                    .map((cartItem) => TransactionDetail(
                          productId: cartItem.product.id,
                          qty: cartItem.quantity,
                          price: cartItem.subtotal
                              .toDouble(), // Convert Decimal to double
                        ))
                    .toList(),
              );

              try {
                // Panggil metode createTransaction dari objek api
                final Map<String, dynamic> response =
                    await api.createTransaction(transaction.toJson());

                if (response['success'] == true) {
                  // Transaksi berhasil, lakukan penanganan sesuai kebutuhan Anda
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction created successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  String invoiceCode = response['data']['invoice'];
                  // Membersihkan keranjang belanja
                  widget.cart.clear();
                  Navigator.pushReplacementNamed(context, '/pos');
                  // Pindahkan pengguna ke halaman SuccessTransactionPage dengan menyertakan kode invoice
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SuccessTransactionPage(invoiceCode: invoiceCode),
                    ),
                  );
                } else {
                  // Transaksi gagal, tampilkan pesan kesalahan
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction creation failed'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                // Tangani kesalahan jaringan atau lainnya
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('An error occurred: $e'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('CHARGE'),
          ),
        ),
      ),
    );
  }
}
