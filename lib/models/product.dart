class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final int? discountPercent;
  final double? discountedPrice;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrls,
    this.rating = 0,
    this.reviewCount = 0,
    this.discountPercent,
    this.discountedPrice,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    double originalPrice = (map['price'] is int)
        ? (map['price'] as int).toDouble()
        : map['price']?.toDouble() ?? 0.0;

    int? discountPercent = map['discountPercent'];
    double? discountedPrice;

    if (discountPercent != null) {
      discountedPrice = originalPrice * (1 - discountPercent / 100);
    }

    return Product(
      id: id,
      name: map['name'] ?? '',
      price: originalPrice,
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      discountPercent: discountPercent,
      discountedPrice: discountedPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrls': imageUrls,
      'rating': rating,
      'reviewCount': reviewCount,
      'discountPercent': discountPercent,
      'discountedPrice': discountedPrice,
    };
  }
}
