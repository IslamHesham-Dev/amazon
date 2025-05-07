import 'package:flutter/material.dart';
import '../models/product.dart';

enum SortOption {
  priceHighToLow,
  priceLowToHigh,
  rating,
  newest,
}

class SortButton extends StatelessWidget {
  final List<Product> products;
  final Function(List<Product>) onSortChanged;

  const SortButton({
    Key? key,
    required this.products,
    required this.onSortChanged,
  }) : super(key: key);

  void _showSortMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<SortOption>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<SortOption>(
          value: SortOption.newest,
          child: Text('Newest'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.priceHighToLow,
          child: Text('Price: High to Low'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.priceLowToHigh,
          child: Text('Price: Low to High'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.rating,
          child: Text('Top Rated'),
        ),
      ],
    ).then((SortOption? value) {
      if (value != null) {
        _applySorting(value);
      }
    });
  }

  void _applySorting(SortOption sortOption) {
    List<Product> sortedProducts = List.from(products);

    switch (sortOption) {
      case SortOption.priceHighToLow:
        sortedProducts.sort((a, b) {
          final priceA = a.discountedPrice ?? a.price;
          final priceB = b.discountedPrice ?? b.price;
          return priceB.compareTo(priceA);
        });
        break;
      case SortOption.priceLowToHigh:
        sortedProducts.sort((a, b) {
          final priceA = a.discountedPrice ?? a.price;
          final priceB = b.discountedPrice ?? b.price;
          return priceA.compareTo(priceB);
        });
        break;
      case SortOption.rating:
        sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.newest:
        // In a real app, you'd have a timestamp field
        // Here we just keep the original order
        break;
    }

    onSortChanged(sortedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sort, color: Colors.white),
      onPressed: () => _showSortMenu(context),
      tooltip: 'Sort Products',
    );
  }
}
