import 'package:intl/intl.dart';

class FormatUtils {
  static final NumberFormat rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final NumberFormat rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  static final NumberFormat stockFormat = NumberFormat.currency(
    locale: 'id_ID',
    decimalDigits: 0,
    symbol: 'Stock ',
  );

  static String formatStock(int stock) {
    return stockFormat.format(stock);
  }
}
