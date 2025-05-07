import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_filters.dart';

class FilterButton extends StatelessWidget {
  final List<Product> products;
  final Function(List<Product>) onFilterChanged;

  const FilterButton({
    Key? key,
    required this.products,
    required this.onFilterChanged,
  }) : super(key: key);

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ProductFilters(
                products: products,
                onFilterChanged: onFilterChanged,
                onClose: () => Navigator.pop(context),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list, color: Colors.white),
      onPressed: () => _showFilterBottomSheet(context),
      tooltip: 'Filter & Sort',
    );
  }
}
