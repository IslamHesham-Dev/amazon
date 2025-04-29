import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => (product.discountedPrice ?? product.price) * quantity;

  Map<String, dynamic> toMap() {
    final effectivePrice = product.discountedPrice ?? product.price;

    return {
      'productId': product.id,
      'name': product.name,
      'price': effectivePrice,
      'originalPrice': product.price,
      'discountPercent': product.discountPercent,
      'imageUrl': product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final price = json['price'] ?? 0.0;
    final originalPrice = json['originalPrice'] ?? price;
    final discountPercent = json['discountPercent'];

    double? discountedPrice;
    if (discountPercent != null) {
      discountedPrice = price;
    }

    return CartItem(
      product: Product(
        id: json['productId'],
        name: json['name'],
        price: originalPrice,
        description: '',
        imageUrls: json['imageUrl'] != null && json['imageUrl'].isNotEmpty
            ? [json['imageUrl']]
            : [],
        rating: 0,
        reviewCount: 0,
        discountPercent: discountPercent,
        discountedPrice: discountedPrice,
      ),
      quantity: json['quantity'],
    );
  }
}
