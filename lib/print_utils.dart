// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:vitapos/utils.dart';
import 'package:vitapos/printerenum.dart' as printenum;
import 'package:intl/intl.dart';

class PrintUtils {
  static final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;

  static Future<void> printTransaction(
      BuildContext context, // Add BuildContext parameter
      Map<String, dynamic> transactionData) async {
    bool isConnected = await _bluetooth.isConnected ?? false;

    if (isConnected) {
      try {
        // Show "Printing in progress" Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sedang mencetak...'),
            duration: Duration(seconds: 3),
          ),
        );

        final transactionDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(transactionData['created_at']));
        final transactionTime = DateFormat('HH:mm:ss')
            .format(DateTime.parse(transactionData['created_at']));
        _bluetooth.printNewLine();
        // Print products
        List<dynamic> details = transactionData['details'];
        // final invoice = transactionData['invoice'];
        // final sub_total = transactionData['sub_total'];
        // final grand_total = transactionData['grand_total'];
        // final discount = transactionData['discount'];

        for (var detail in details) {
          final product = detail['product'] ?? {};
          final productName = product['title'] ?? '';
          final productPrice = detail['price'] ?? 0;
          final productQty = detail['qty'] ?? 0;
          final productQR = product['barcode'] ?? '';
          // Print the product as many times as the quantity
          for (int i = 0; i < productQty; i++) {
            _bluetooth.printCustom('-' * 32, 1, 0);
            _bluetooth.printNewLine();
            _bluetooth.printCustom("AbiPOS", 2, 1);
            _bluetooth.printNewLine();
            _bluetooth.printQRcode(
                productQR, 200, 200, printenum.Align.center.val);

            // _bluetooth.printCustom(productName, printenum.Size.medium, printenum.Align.right);
            _bluetooth.printCustom(
                productName, printenum.Size.bold.val, printenum.Align.left.val);

            _bluetooth.printLeftRight(
                "Invoice :", transactionData['invoice'], 1);

            _bluetooth.printLeftRight("Tanggal :", transactionDate, 1);
            _bluetooth.printLeftRight("Waktu :", transactionTime, 1);
            _bluetooth.printLeftRight(
              'Harga :',
              FormatUtils.rupiahFormat.format(productPrice),
              1,
            );
            _bluetooth.printCustom('-' * 32, 1, 0);
          }
        }
        _bluetooth.paperCut();

        // Show "Printing successful" BottomSheet
        showModalBottomSheet(
          context: context,
          builder: (BuildContext bottomSheetContext) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Cetak berhasil',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(bottomSheetContext)
                          .pop(); // Close the BottomSheet
                    },
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } catch (e) {
        // Show "Printing failed" Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cetak gagal'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // Show "Printer is not connected" Snackbar
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bottomSheetContext) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.print,
                  size: 48,
                  color: Colors.red, // Change the icon color
                ),
                const SizedBox(height: 20),
                const Text(
                  'Printer tidak terhubung',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mohon pastikan printer terhubung dan coba lagi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    Navigator.of(bottomSheetContext)
                        .pop(); // Close the BottomSheet
                  },
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
