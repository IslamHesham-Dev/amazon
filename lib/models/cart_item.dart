import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product(
        id: json['productId'],
        name: json['name'],
        price: json['price'],
        description: '',
        imageUrls: json['imageUrl'] != null && json['imageUrl'].isNotEmpty
            ? [json['imageUrl']]
            : [],
        rating: 0,
        reviewCount: 0,
      ),
      quantity: json['quantity'],
    );
  }
}
