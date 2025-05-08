import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load orders (simulated)
  Future<void> fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _setLoading(true);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // We're not actually fetching from a server, just returning what's already in memory
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Place a new order
  Future<Order?> placeOrder(
    List<CartItem> cartItems,
    double totalAmount,
    String address,
    String paymentMethod, {
    bool isGift = false,
    String? giftRecipientName,
    String? giftMessage,
    bool giftWrapped = false,
  }) async {
    _setLoading(true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _setError("User not authenticated");
      _setLoading(false);
      return null;
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate a random order ID
      final orderId =
          'ORD-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}';

      // Create new order
      final newOrder = Order(
        id: orderId,
        userId: user.uid,
        items: List.from(cartItems),
        totalAmount: totalAmount,
        shippingAddress: address,
        paymentMethod: paymentMethod,
        status: OrderStatus.processing,
        isGift: isGift,
        giftRecipientName: giftRecipientName,
        giftMessage: giftMessage,
        giftWrapped: giftWrapped,
      );

      // Add to orders list
      _orders.add(newOrder);

      notifyListeners();
      return newOrder;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    _setLoading(true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _setError("User not authenticated");
      _setLoading(false);
      return false;
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex == -1) {
        return false;
      }

      final existingOrder = _orders[orderIndex];

      // Create a new order with canceled status
      final updatedOrder = Order(
        id: existingOrder.id,
        userId: user.uid,
        items: existingOrder.items,
        totalAmount: existingOrder.totalAmount,
        shippingAddress: existingOrder.shippingAddress,
        paymentMethod: existingOrder.paymentMethod,
        orderDate: existingOrder.orderDate,
        status: OrderStatus.canceled,
        isGift: existingOrder.isGift,
        giftRecipientName: existingOrder.giftRecipientName,
        giftMessage: existingOrder.giftMessage,
        giftWrapped: existingOrder.giftWrapped,
      );

      // Replace the old order with the updated one
      _orders[orderIndex] = updatedOrder;

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
