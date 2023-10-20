import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import library ini

class SetDiscountModal extends StatefulWidget {
  const SetDiscountModal({Key? key}) : super(key: key);

  @override
  SetDiscountModalState createState() => SetDiscountModalState();
}

class SetDiscountModalState extends State<SetDiscountModal> {
  bool _isPercentageSelected = true;

  // Buat instance dari FilteringTextInputFormatter untuk memfilter input hanya double
  final doubleFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d+\.?\d{0,2}$'),
    replacementString: '',
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Set Discount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Radio(
                  value: true,
                  groupValue: _isPercentageSelected,
                  onChanged: (value) {
                    setState(() {
                      _isPercentageSelected = value as bool;
                    });
                  },
                ),
                const Text('Percentage'),
                Radio(
                  value: false,
                  groupValue: _isPercentageSelected,
                  onChanged: (value) {
                    setState(() {
                      _isPercentageSelected = value as bool;
                    });
                  },
                ),
                const Text('Value'),
              ],
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Enter discount',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
              ],
              onChanged: (value) {
                setState(() {
                  if (_isPercentageSelected) {
                  } else {}
                });
              },
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk menyimpan pengaturan diskon di sini
                  // Anda dapat memeriksa _isPercentageSelected untuk menentukan jenis diskon yang harus disimpan.
                  // Misalnya, jika _isPercentageSelected adalah true, Anda dapat menyimpan _discountPercentage ke penyimpanan atau menyimpannya di suatu tempat.
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
