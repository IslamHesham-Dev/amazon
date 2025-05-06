import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/sample_products.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _discountedProducts = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Method to get all products
  Future<void> fetchProducts() async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Use the sample data instead of Firestore
      _products = List.from(SampleProducts.products);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add method to store discounted products (called from PromotionsPage)
  void storeDiscountedProduct(Product product) {
    // Check if product already exists in the list
    int existingIndex =
        _discountedProducts.indexWhere((p) => p.id == product.id);

    if (existingIndex >= 0) {
      // Replace existing product
      _discountedProducts[existingIndex] = product;
    } else {
      // Add new product
      _discountedProducts.add(product);
    }
  }

  // Method to get product by ID
  Future<Product> getProductById(String productId) async {
    try {
      // First check if it's in our discounted products list
      for (final product in _discountedProducts) {
        if (product.id == productId) {
          return product;
        }
      }

      // Then check if it's in our regular products list
      if (_products.isNotEmpty) {
        for (final product in _products) {
          if (product.id == productId) {
            return product;
          }
        }
      }

      // Otherwise check sample data
      await Future.delayed(const Duration(milliseconds: 300));

      for (final product in SampleProducts.products) {
        if (product.id == productId) {
          return product;
        }
      }

      // If we get here, no product was found
      throw Exception("Product not found with ID: $productId");
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  // Method to get products by category (phone, tv, etc)
  List<Product> getProductsByCategory(String category) {
    category = category.toLowerCase();

    // Create categories based on product names or descriptions
    if (category == 'phone' ||
        category == 'phones' ||
        category == 'smartphone') {
      return _products
          .where((p) =>
              p.name.toLowerCase().contains('phone') ||
              p.name.toLowerCase().contains('iphone') ||
              p.name.toLowerCase().contains('galaxy'))
          .toList();
    } else if (category == 'tablet' || category == 'tablets') {
      return _products
          .where((p) =>
              p.name.toLowerCase().contains('tablet') ||
              p.name.toLowerCase().contains('ipad') ||
              p.name.toLowerCase().contains('tab'))
          .toList();
    } else if (category == 'tv' || category == 'television') {
      return _products
          .where((p) =>
              p.name.toLowerCase().contains('tv') ||
              p.name.toLowerCase().contains('television'))
          .toList();
    } else if (category == 'audio' || category == 'headphones') {
      return _products
          .where((p) =>
              p.name.toLowerCase().contains('headphone') ||
              p.name.toLowerCase().contains('earbuds') ||
              p.name.toLowerCase().contains('audio'))
          .toList();
    } else if (category == 'laptop' || category == 'computer') {
      return _products
          .where((p) =>
              p.name.toLowerCase().contains('macbook') ||
              p.name.toLowerCase().contains('laptop') ||
              p.name.toLowerCase().contains('computer'))
          .toList();
    } else {
      // Return all products if category doesn't match
      return _products;
    }
  }

  // Method to add review to a product (locally only)
  Future<void> addReview(
      String productId, double rating, String comment, String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Find product and update its rating and review count in-memory
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final product = _products[index];
        final totalRating = (product.rating * product.reviewCount) + rating;
        final newReviewCount = product.reviewCount + 1;
        final newRating = totalRating / newReviewCount;

        // Create a new product with updated rating
        _products[index] = Product(
          id: product.id,
          name: product.name,
          price: product.price,
          description: product.description,
          imageUrls: product.imageUrls,
          rating: newRating,
          reviewCount: newReviewCount,
        );

        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
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
