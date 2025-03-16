import 'package:flutter/foundation.dart'; // For @immutable annotation

@immutable
class Invoice {
  final String orderNo;
  final double grandTotal;
  final String currency;
  final Customer customer;
  final String deliveryDate;

  const Invoice({
    required this.orderNo,
    required this.grandTotal,
    required this.currency,
    required this.customer,
    required this.deliveryDate,
  });

  // Factory constructor to create an Invoice from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      orderNo: json['order_no'] as String,
      grandTotal: (json['grand_total'] as num).toDouble(),
      currency: json['currency'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      deliveryDate: json['shipping']['delivery_date'] as String,
    );
  }

  // Convert Invoice to JSON (optional, for serialization)
  Map<String, dynamic> toJson() {
    return {
      'order_no': orderNo,
      'grand_total': grandTotal,
      'currency': currency,
      'customer': customer.toJson(),
      'shipping': {'delivery_date': deliveryDate},
    };
  }
}

@immutable
class Customer {
  final String id;
  final String name;
  final String phoneNumber;

  const Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
    };
  }
}