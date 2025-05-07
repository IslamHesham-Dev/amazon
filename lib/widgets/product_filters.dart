import 'package:flutter/material.dart';
import '../models/product.dart';

enum SortOption {
  priceHighToLow,
  priceLowToHigh,
  rating,
  newest,
}

class ProductFilters extends StatefulWidget {
  final List<Product> products;
  final Function(List<Product>) onFilterChanged;
  final Function() onClose;

  const ProductFilters({
    Key? key,
    required this.products,
    required this.onFilterChanged,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ProductFilters> createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {
  // Available categories based on product names
  final List<String> _categories = [
    'All',
    'Phone',
    'Tablet',
    'TV',
    'Audio',
    'Laptop',
    'Gaming',
  ];

  // Filter state
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 3000);
  SortOption _sortOption = SortOption.newest;
  double _minPrice = 0;
  double _maxPrice = 3000;

  @override
  void initState() {
    super.initState();
    _initPriceRange();
  }

  void _initPriceRange() {
    if (widget.products.isNotEmpty) {
      _minPrice = widget.products
          .map((p) => p.discountedPrice ?? p.price)
          .reduce((a, b) => a < b ? a : b);
      _maxPrice = widget.products
          .map((p) => p.discountedPrice ?? p.price)
          .reduce((a, b) => a > b ? a : b);
      _priceRange = RangeValues(_minPrice, _maxPrice);
    }
  }

  void _applyFilters() {
    List<Product> filteredProducts = List.from(widget.products);

    // Apply category filter
    if (_selectedCategory != 'All') {
      filteredProducts = filteredProducts.where((product) {
        final name = product.name.toLowerCase();
        final description = product.description.toLowerCase();
        final category = _selectedCategory.toLowerCase();

        return name.contains(category) || description.contains(category);
      }).toList();
    }

    // Apply price range filter
    filteredProducts = filteredProducts.where((product) {
      final price = product.discountedPrice ?? product.price;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    // Apply sorting
    switch (_sortOption) {
      case SortOption.priceHighToLow:
        filteredProducts.sort((a, b) {
          final priceA = a.discountedPrice ?? a.price;
          final priceB = b.discountedPrice ?? b.price;
          return priceB.compareTo(priceA);
        });
        break;
      case SortOption.priceLowToHigh:
        filteredProducts.sort((a, b) {
          final priceA = a.discountedPrice ?? a.price;
          final priceB = b.discountedPrice ?? b.price;
          return priceA.compareTo(priceB);
        });
        break;
      case SortOption.rating:
        filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.newest:
        // In a real app, you'd have a timestamp field
        // Here we just keep the original order
        break;
    }

    widget.onFilterChanged(filteredProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((category) {
              return ChoiceChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _applyFilters();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_priceRange.start.toInt()}'),
              Text('\$${_priceRange.end.toInt()}'),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: _minPrice,
            max: _maxPrice,
            divisions: 100,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
            onChangeEnd: (RangeValues values) {
              _applyFilters();
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Price: High to Low'),
                selected: _sortOption == SortOption.priceHighToLow,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _sortOption = SortOption.priceHighToLow;
                    });
                    _applyFilters();
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Price: Low to High'),
                selected: _sortOption == SortOption.priceLowToHigh,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _sortOption = SortOption.priceLowToHigh;
                    });
                    _applyFilters();
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Top Rated'),
                selected: _sortOption == SortOption.rating,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _sortOption = SortOption.rating;
                    });
                    _applyFilters();
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Newest'),
                selected: _sortOption == SortOption.newest,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _sortOption = SortOption.newest;
                    });
                    _applyFilters();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.onClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9900),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Apply Filters',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
