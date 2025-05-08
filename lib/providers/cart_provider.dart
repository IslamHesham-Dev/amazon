import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0, (total, item) => total + item.total);
  }

  // Local cart operations
  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex >= 0) {
      // Item already in cart, update quantity
      _items[existingItemIndex].quantity += quantity;
    } else {
      // Add new item to cart
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Cart sharing functionality
  String encodeCartForSharing() {
    // Create a shareable format of the cart
    final cartData = {
      'items': _items.map((item) => item.toJson()).toList(),
    };

    // Encode to JSON and then to base64 for safe sharing
    return base64Encode(utf8.encode(jsonEncode(cartData)));
  }

  void importSharedCart(String encodedCart) {
    try {
      // Decode the shared cart data
      final String jsonStr = utf8.decode(base64Decode(encodedCart));
      final Map<String, dynamic> cartData = jsonDecode(jsonStr);

      final List<dynamic> itemsData = cartData['items'] as List<dynamic>;
      final List<CartItem> newItems = itemsData
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();

      // Replace the current cart with the imported one
      _items.clear();
      _items.addAll(newItems);
      notifyListeners();
    } catch (e) {
      _setError('Failed to import cart: $e');
    }
  }

  // Merge a shared cart with the current cart
  void mergeSharedCart(String encodedCart) {
    try {
      // Decode the shared cart data
      final String jsonStr = utf8.decode(base64Decode(encodedCart));
      final Map<String, dynamic> cartData = jsonDecode(jsonStr);

      final List<dynamic> itemsData = cartData['items'] as List<dynamic>;
      final List<CartItem> sharedItems = itemsData
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();

      // Add each shared item to the cart
      for (var sharedItem in sharedItems) {
        final existingItemIndex = _items
            .indexWhere((item) => item.product.id == sharedItem.product.id);

        if (existingItemIndex >= 0) {
          // Item already in cart, update quantity
          _items[existingItemIndex].quantity += sharedItem.quantity;
        } else {
          // Add new item to cart
          _items.add(sharedItem);
        }
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to merge cart: $e');
    }
  }

  // Simulate fetching cart from storage (we're just using in-memory data)
  Future<void> fetchCartFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _setLoading(true);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Since we're storing everything locally, we don't need to do anything here
      // We already have our cart items in memory

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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
