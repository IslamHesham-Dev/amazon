import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/sample_products.dart';
import 'product_detail_page.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  List<Map<String, dynamic>> _dealProducts = [];
  List<Map<String, dynamic>> _filteredDealProducts = [];
  String _selectedCategory = 'All Deals';

  @override
  void initState() {
    super.initState();
    _prepareDealProducts();
  }

  void _prepareDealProducts() {
    // Create a list of products with discount information
    final List<Product> dealsProducts = [
      // Add some products from SampleProducts
      SampleProducts.products.firstWhere((p) => p.id == '3'), // Sony Headphones
      SampleProducts.products.firstWhere((p) => p.id == '8'), // Bose Earbuds

      // Add exclusive deals products not in the home page
      Product(
        id: 'deal1',
        name: 'Instant Pot Duo Plus 9-in-1 Electric Pressure Cooker',
        price: 149.99,
        description:
            '''The Instant Pot Duo Plus is the next evolution in the Duo Series, the #1 best-selling cooker. The Duo Plus 9-in-1 programmable cooker combines all the great features that made the Duo the #1 best-seller, with new and improved features.''',
        imageUrls: [
          'https://m.media-amazon.com/images/I/71V1LrY1MSL._AC_SL1500_.jpg',
          'https://m.media-amazon.com/images/I/81D2IfxdZIL._AC_SL1500_.jpg',
        ],
        rating: 4.7,
        reviewCount: 1255,
      ),
      Product(
        id: 'deal2',
        name: 'Apple Watch Series 8 GPS + Cellular 45mm',
        price: 499.99,
        description:
            '''The Apple Watch Series 8 features temperature sensing, Crash Detection, sleep stages, and advanced workout metrics to take your training to the next level. The aluminum case is lightweight and made from 100 percent recycled aerospace-grade alloy.''',
        imageUrls: [
          'https://m.media-amazon.com/images/I/71XMTLtZd5L._AC_SL1500_.jpg',
          'https://m.media-amazon.com/images/I/61sNes1LXOL._AC_SL1500_.jpg',
        ],
        rating: 4.8,
        reviewCount: 986,
      ),
      Product(
        id: 'deal3',
        name: 'Fitbit Charge 5 Advanced Fitness & Health Tracker',
        price: 149.95,
        description:
            '''Optimize your workout routine with a Daily Readiness Score that reveals if you're ready to exercise or should focus on recovery (Requires Fitbit Premium membership). Take a daily Stress Management Score to see your body's response to stress.''',
        imageUrls: [
          'https://m.media-amazon.com/images/I/51q7FojdicL._AC_SY355_.jpg',
          'https://m.media-amazon.com/images/I/71ZSVO9kuKL._AC_SL1500_.jpg',
        ],
        rating: 4.3,
        reviewCount: 732,
      ),
      Product(
        id: 'deal4',
        name: 'Logitech MX Master 3S Wireless Mouse',
        price: 99.99,
        description:
            '''MX Master 3S is an advanced wireless mouse with ultra-fast, precise, quiet clicks and an 8K DPI track-on-glass sensor that tracks on any surface, including glass. The electromagnetic wheel provides remarkable speed, precision, and near-silence.''',
        imageUrls: [
          'https://m.media-amazon.com/images/I/61gjlA1IXlL._AC_SX425_.jpg',
          'https://m.media-amazon.com/images/I/71a7jX-fIGL._AC_SL1500_.jpg',
        ],
        rating: 4.7,
        reviewCount: 598,
      ),
      Product(
        id: 'deal5',
        name: 'Philips Sonicare DiamondClean 9700 Smart Electric Toothbrush',
        price: 329.99,
        description:
            '''The Philips Sonicare DiamondClean Smart is our best ever toothbrush, for complete oral care. Four high-performance brush heads let you focus on all areas of your oral health, and our Smart Sensor technology gives you personalized feedback and coaching.''',
        imageUrls: [
          'https://m.media-amazon.com/images/I/71CLrfnTDNL._AC_SX425_.jpg',
          'https://m.media-amazon.com/images/I/71S0RugV02L._SL1500_.jpg',
        ],
        rating: 4.6,
        reviewCount: 413,
      ),
      Product(
        id: 'deal6',
        name: 'Samsung 34" Odyssey G5 Ultra-Wide Gaming Monitor',
        price: 599.99,
        description:
            '''Discover a new level of immersion with the Samsung 34" Odyssey G5. The 1000R curved ultra-wide screen wraps around your field of vision, drawing you into the heart of the action. With WQHD resolution, AMD FreeSync Premium, and 165Hz refresh rate, your games will look incredibly smooth and detailed.''',
        imageUrls: [
          'https://m.media-amazon.com/images/I/61XDeaOrrKL._AC_SL1500_.jpg',
          'https://m.media-amazon.com/images/I/71it9pfhHhL._AC_SL1500_.jpg',
        ],
        rating: 4.5,
        reviewCount: 367,
      ),
    ];

    // Apply discounts to products
    _dealProducts = dealsProducts
        .map((product) {
          // Apply different discount percentages based on product ID
          int discountPercent = 0;

          // Existing products
          if (product.id == '3') {
            discountPercent = 35; // Sony Headphones
          } else if (product.id == '8') {
            discountPercent = 25; // Bose Earbuds
          }
          // New products
          else if (product.id == 'deal1') {
            discountPercent = 40; // Instant Pot
          } else if (product.id == 'deal2') {
            discountPercent = 15; // Apple Watch
          } else if (product.id == 'deal3') {
            discountPercent = 30; // Fitbit
          } else if (product.id == 'deal4') {
            discountPercent = 20; // Logitech Mouse
          } else if (product.id == 'deal5') {
            discountPercent = 45; // Philips Sonicare
          } else if (product.id == 'deal6') {
            discountPercent = 25; // Samsung Monitor
          }

          if (discountPercent > 0) {
            double discountedPrice =
                product.price * (1 - discountPercent / 100);
            return {
              'product': product,
              'discountPercent': discountPercent,
              'originalPrice': product.price,
              'discountedPrice': discountedPrice,
              'category': _getCategoryForProduct(product),
            };
          }
          return null;
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    _filterProductsByCategory(_selectedCategory);
  }

  // Helper method to determine product category
  String _getCategoryForProduct(Product product) {
    final name = product.name.toLowerCase();
    final description = product.description.toLowerCase();

    if (name.contains('headphone') ||
        name.contains('earbuds') ||
        name.contains('audio') ||
        name.contains('sony wh') ||
        name.contains('bose')) {
      return 'Audio';
    } else if (name.contains('monitor') || name.contains('gaming')) {
      return 'Gaming';
    } else if (name.contains('watch') || name.contains('fitbit')) {
      return 'Wearables';
    } else if (name.contains('pot') ||
        name.contains('cooker') ||
        name.contains('toothbrush')) {
      return 'Kitchen';
    } else if (name.contains('mouse') || name.contains('computer')) {
      return 'Electronics';
    } else if (name.contains('smart') || name.contains('sonicare')) {
      return 'Smart Home';
    }

    // Default category is Electronics
    return 'Electronics';
  }

  // Filter products based on selected category
  void _filterProductsByCategory(String category) {
    setState(() {
      _selectedCategory = category;

      if (category == 'All Deals') {
        _filteredDealProducts = List.from(_dealProducts);
      } else {
        _filteredDealProducts = _dealProducts.where((dealData) {
          return dealData['category'] == category;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Deals'),
        backgroundColor: const Color(0xFF232F3E),
        foregroundColor: Colors.white,
      ),
      body: _dealProducts.isEmpty
          ? const Center(child: Text('No deals available at the moment.'))
          : CustomScrollView(
              slivers: [
                // Featured banner
                SliverToBoxAdapter(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF7CA00), Color(0xFFFF9900)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SPECIAL DEALS',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Up to 45% OFF on select products',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Deal categories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip('All Deals',
                              isSelected: _selectedCategory == 'All Deals'),
                          _buildCategoryChip('Electronics',
                              isSelected: _selectedCategory == 'Electronics'),
                          _buildCategoryChip('Audio',
                              isSelected: _selectedCategory == 'Audio'),
                          _buildCategoryChip('Gaming',
                              isSelected: _selectedCategory == 'Gaming'),
                          _buildCategoryChip('Smart Home',
                              isSelected: _selectedCategory == 'Smart Home'),
                          _buildCategoryChip('Wearables',
                              isSelected: _selectedCategory == 'Wearables'),
                          _buildCategoryChip('Kitchen',
                              isSelected: _selectedCategory == 'Kitchen'),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Limited Time Deals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Grid of deal products
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: _filteredDealProducts.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No products found in $_selectedCategory category',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      _filterProductsByCategory('All Deals'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9900),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Show All Deals'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final dealData = _filteredDealProducts[index];
                              final product = dealData['product'] as Product;
                              final discountPercent =
                                  dealData['discountPercent'] as int;
                              final originalPrice =
                                  dealData['originalPrice'] as double;
                              final discountedPrice =
                                  dealData['discountedPrice'] as double;

                              return _buildDealProductCard(
                                context,
                                product: product,
                                discountPercent: discountPercent,
                                originalPrice: originalPrice,
                                discountedPrice: discountedPrice,
                              );
                            },
                            childCount: _filteredDealProducts.length,
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () => _filterProductsByCategory(label),
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor:
              isSelected ? const Color(0xFFFF9900) : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildDealProductCard(
    BuildContext context, {
    required Product product,
    required int discountPercent,
    required double originalPrice,
    required double discountedPrice,
  }) {
    final String category = _getCategoryForProduct(product);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: product.id),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discount badge
            Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      product.imageUrls[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Discount badge
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      '$discountPercent% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                // Category badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                      ),
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
              ],
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price information
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFB12704),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${originalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  // Rating
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(
                        ' ${product.rating.toStringAsFixed(1)}',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
