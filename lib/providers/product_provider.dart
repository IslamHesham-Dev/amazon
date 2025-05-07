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

    // Specific product IDs for certain categories
    final audioProductIds = ['3', '8']; // Sony headphones, Bose earbuds
    final tabletProductIds = ['9', '10']; // Samsung Tab, Kindle
    final gamingProductIds = ['5']; // Nintendo Switch

    // Create categories based on product names, descriptions, or specific product IDs
    if (category == 'phone' ||
        category == 'phones' ||
        category == 'smartphone') {
      return _products.where((p) {
        final name = p.name.toLowerCase();
        return ((name.contains('phone') && !name.contains('headphone')) ||
                name.contains('iphone') ||
                (name.contains('galaxy') && !name.contains('tab'))) &&
            !audioProductIds.contains(p.id);
      }).toList();
    } else if (category == 'tablet' || category == 'tablets') {
      return _products.where((p) {
        final name = p.name.toLowerCase();
        return (name.contains('tablet') ||
            name.contains('ipad') ||
            name.contains(' tab ') ||
            name.contains('tab s') ||
            name.contains('kindle') ||
            tabletProductIds.contains(p.id));
      }).toList();
    } else if (category == 'tv' || category == 'television') {
      return _products.where((p) {
        final name = p.name.toLowerCase();
        return name.contains('tv') || name.contains('television');
      }).toList();
    } else if (category == 'audio' || category == 'headphones') {
      return _products.where((p) {
        final name = p.name.toLowerCase();
        return (name.contains('headphone') ||
                name.contains('earbuds') ||
                name.contains('audio') ||
                name.contains('sony wh') ||
                name.contains('bose') ||
                name.contains('quietcomfort') ||
                audioProductIds.contains(p.id)) &&
            !name.contains('nintendo');
      }).toList();
    } else if (category == 'laptop' || category == 'computer') {
      return _products.where((p) {
        final name = p.name.toLowerCase();
        return name.contains('macbook') ||
            name.contains('laptop') ||
            name.contains('computer');
      }).toList();
    } else if (category == 'gaming') {
      return _products.where((p) {
        final name = p.name.toLowerCase();
        return name.contains('nintendo') ||
            name.contains('switch') ||
            name.contains('playstation') ||
            name.contains('xbox') ||
            name.contains('gaming') ||
            gamingProductIds.contains(p.id);
      }).toList();
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
