import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  // In-memory storage for wishlist items
  final List<Product> _wishlistItems = [];

  // Getter for wishlist items
  List<Product> get wishlistItems => _wishlistItems;

  // Check if a product is in the wishlist
  bool isInWishlist(String productId) {
    return _wishlistItems.any((product) => product.id == productId);
  }

  // Add a product to the wishlist
  void addToWishlist(Product product) {
    if (!isInWishlist(product.id)) {
      _wishlistItems.add(product);
      notifyListeners();
    }
  }

  // Remove a product from the wishlist
  void removeFromWishlist(String productId) {
    _wishlistItems.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  // Toggle a product in the wishlist (add if not present, remove if present)
  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }

  // Clear all items from the wishlist
  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
