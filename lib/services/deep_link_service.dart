import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import '../screens/shared_cart_page.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  bool _isInitialized = false;
  StreamSubscription? _linkSubscription;

  factory DeepLinkService() {
    return _instance;
  }

  DeepLinkService._internal();

  Future<void> initialize(BuildContext context) async {
    if (_isInitialized) return;

    try {
      // Handle any incoming links
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink, context);
      }

      // Listen for new links
      _linkSubscription = linkStream.listen((String? link) {
        if (link != null) {
          _handleDeepLink(link, context);
        }
      }, onError: (dynamic error) {
        // Handle errors
        print('Deep link error: $error');
      });

      _isInitialized = true;
    } on PlatformException catch (e) {
      print('Failed to initialize deep links: ${e.message}');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  void _handleDeepLink(String link, BuildContext context) {
    // Handle cart sharing links
    Uri uri = Uri.parse(link);

    if (uri.host == 'cart' || uri.path == '/cart') {
      final encodedCart = uri.queryParameters['data'];
      if (encodedCart != null && encodedCart.isNotEmpty) {
        // Navigate to the shared cart page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SharedCartPage(encodedCart: encodedCart),
          ),
        );
      }
    }
  }
}
