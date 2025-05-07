import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_button.dart';
import '../widgets/sort_button.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<Product> _displayedProducts = [];
  bool _isFiltering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(productProvider.products);
      } else {
        _filteredProducts = productProvider.products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // Apply displayed products based on current filter state
      _updateDisplayedProducts();
    });
  }

  void _updateDisplayedProducts() {
    setState(() {
      _displayedProducts =
          _isFiltering ? _displayedProducts : _filteredProducts;
    });
  }

  void _handleFilterChanged(List<Product> filteredProducts) {
    setState(() {
      _displayedProducts = filteredProducts;
      _isFiltering = true;
    });
  }

  void _handleSortChanged(List<Product> sortedProducts) {
    setState(() {
      _displayedProducts = sortedProducts;
      _isFiltering = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF232F3E),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Amazon',
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black54),
                      onPressed: () {
                        _searchController.clear();
                        _filterProducts('');
                        setState(() {
                          _isFiltering = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: _filterProducts,
          ),
        ),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SortButton(
                products: _isFiltering
                    ? _displayedProducts
                    : (_searchController.text.isEmpty
                        ? productProvider.products
                        : _filteredProducts),
                onSortChanged: _handleSortChanged,
              );
            },
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return FilterButton(
                products: productProvider.products,
                onFilterChanged: _handleFilterChanged,
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${productProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => productProvider.fetchProducts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Determine which products to display based on search and filters
          final products = _isFiltering
              ? _displayedProducts
              : (_searchController.text.isEmpty
                  ? productProvider.products
                  : _filteredProducts);

          if (products.isEmpty) {
            return const Center(
              child: Text('No products found.'),
            );
          }

          return Column(
            children: [
              if (_isFiltering)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      const Text(
                        'Filtered results',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isFiltering = false;
                            _filterProducts(_searchController.text);
                          });
                        },
                        child: const Text('Clear Filters'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(productId: product.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
