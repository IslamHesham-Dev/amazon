class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrls,
    this.rating = 0,
    this.reviewCount = 0,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
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
    };
  }
}
