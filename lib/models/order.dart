import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import 'package:uuid/uuid.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  canceled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.canceled:
        return 'Canceled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.canceled:
        return Colors.red;
    }
  }

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'canceled':
        return OrderStatus.canceled;
      default:
        return OrderStatus.pending; // Default status
    }
  }
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String shippingAddress;
  final String paymentMethod;
  final DateTime orderDate;
  final OrderStatus status;
  final bool isGift;
  final String? giftRecipientName;
  final String? giftMessage;
  final bool giftWrapped;

  Order({
    String? id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    DateTime? orderDate,
    this.status = OrderStatus.pending,
    this.isGift = false,
    this.giftRecipientName,
    this.giftMessage,
    this.giftWrapped = false,
  })  : id = id ?? const Uuid().v4(),
        orderDate = orderDate ?? DateTime.now();

  String get formattedDate {
    return '${orderDate.month}/${orderDate.day}/${orderDate.year}';
  }

  String get statusText => status.displayName;

  Color get statusColor => status.color;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate.toIso8601String(),
      'status': status.name,
      'isGift': isGift,
      'giftRecipientName': giftRecipientName,
      'giftMessage': giftMessage,
      'giftWrapped': giftWrapped,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
      orderDate: DateTime.parse(json['orderDate']),
      status: OrderStatus.fromString(json['status']),
      isGift: json['isGift'] ?? false,
      giftRecipientName: json['giftRecipientName'],
      giftMessage: json['giftMessage'],
      giftWrapped: json['giftWrapped'] ?? false,
    );
  }
}
