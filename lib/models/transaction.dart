class Transaction {
  final int? customerId;
  final double cash;
  final double change;
  final double discount;
  final double totalAmount;
  final String paymentMethod;
  final double remainingAmount;
  final String status;
  final List<TransactionDetail> transactionDetails;

  Transaction({
    this.customerId,
    required this.cash,
    required this.change,
    required this.discount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.remainingAmount,
    required this.status,
    required this.transactionDetails,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final List<dynamic> details = json['transaction_details'];
    final List<TransactionDetail> transactionDetails =
        details.map((detail) => TransactionDetail.fromJson(detail)).toList();

    return Transaction(
      customerId: json['customer_id'],
      cash: json['cash'].toDouble(),
      change: json['change'].toDouble(),
      discount: json['discount'].toDouble(),
      totalAmount: json['total_amount'].toDouble(),
      paymentMethod: json['payment_method'],
      remainingAmount: json['remaining_amount'].toDouble(),
      status: json['status'],
      transactionDetails: transactionDetails,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'customer_id': customerId,
      'cash': cash,
      'change': change,
      'discount': discount,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'remaining_amount': remainingAmount,
      'status': status,
      'transaction_details':
          transactionDetails.map((detail) => detail.toJson()).toList(),
    };
    return data;
  }
}

class TransactionDetail {
  final int productId;
  final int qty;
  final double price;

  TransactionDetail({
    required this.productId,
    required this.qty,
    required this.price,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      productId: json['product_id'],
      qty: json['qty'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'qty': qty,
      'price': price,
    };
    return data;
  }
}
