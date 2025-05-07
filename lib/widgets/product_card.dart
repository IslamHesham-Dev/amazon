import 'package:flutter/material.dart';
import '../models/product.dart';
import 'wishlist_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  String _getProductCategory() {
    final name = product.name.toLowerCase();
    final description = product.description.toLowerCase();

    // Check for specific product matches first
    if (product.id == '3' ||
        name.contains('sony wh') ||
        name.contains('bose')) {
      return 'Audio';
    }

    if (product.id == '9' || name.contains('galaxy tab')) {
      return 'Tablet';
    }

    if (product.id == '10' || name.contains('kindle')) {
      return 'Tablet';
    }

    if (name.contains('nintendo') ||
        name.contains('switch') ||
        name.contains('playstation') ||
        name.contains('xbox')) {
      return 'Gaming';
    }

    // Then use general category detection
    if ((name.contains('phone') && !name.contains('headphone')) ||
        name.contains('iphone') ||
        (name.contains('galaxy') && !name.contains('tab'))) {
      return 'Phone';
    } else if (name.contains('tablet') ||
        name.contains('ipad') ||
        name.contains(' tab ') ||
        name.contains('tab s')) {
      return 'Tablet';
    } else if (name.contains('tv') || name.contains('television')) {
      return 'TV';
    } else if (name.contains('headphone') ||
        name.contains('earbuds') ||
        name.contains('audio') ||
        name.contains('quietcomfort')) {
      return 'Audio';
    } else if (name.contains('macbook') ||
        name.contains('laptop') ||
        name.contains('computer')) {
      return 'Laptop';
    } else if (name.contains('book') && !name.contains('macbook')) {
      return 'Books';
    } else if (name.contains('vacuum') || name.contains('cleaner')) {
      return 'Home';
    } else {
      return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = _getProductCategory();

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with category badge
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  product.imageUrls.isNotEmpty
                      ? Image.network(
                          product.imageUrls[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child:
                                    Icon(Icons.image_not_supported, size: 50),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Add wishlist button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: WishlistButton(
                      product: product,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        ' (${product.reviewCount})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (product.discountedPrice != null)
                    Row(
                      children: [
                        Text(
                          '\$${product.discountedPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
