import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/wishlist_provider.dart';

class WishlistButton extends StatelessWidget {
  final Product product;
  final Color? iconColor;
  final Color? activeColor;
  final double size;
  final bool showBackground;

  const WishlistButton({
    Key? key,
    required this.product,
    this.iconColor,
    this.activeColor = Colors.red,
    this.size = 24,
    this.showBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final isInWishlist = wishlistProvider.isInWishlist(product.id);

        Widget iconButton = IconButton(
          icon: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_border,
            color: isInWishlist ? activeColor : iconColor,
          ),
          onPressed: () {
            wishlistProvider.toggleWishlist(product);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isInWishlist
                      ? 'Removed from Saved Items'
                      : 'Added to Saved Items',
                ),
                action: SnackBarAction(
                  label: 'VIEW',
                  onPressed: () {
                    Navigator.pushNamed(context, '/wishlist');
                  },
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          iconSize: size,
          splashRadius: size,
        );

        if (showBackground) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: iconButton,
          );
        }

        return iconButton;
      },
    );
  }
}
