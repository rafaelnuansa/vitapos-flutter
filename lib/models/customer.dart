class Customer {
  final int id;
  final String name;
  final String customerCode;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final int? postalCode;
  final int? countryId;
  final String? dob;
  final double? creditLimit;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.name,
    required this.customerCode,
    required this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.postalCode,
    this.countryId,
    this.dob,
    this.creditLimit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      customerCode: json['customer_code'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postal_code'],
      countryId: json['country_id'],
      dob: json['dob'],
      creditLimit: json['credit_limit'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'customer_code': customerCode,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'country_id': countryId,
      'dob': dob,
      'credit_limit': creditLimit,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
