import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime? expiryDate;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.expiryDate,
  });

  factory Promotion.fromMap(String id, Map<String, dynamic> map) {
    return Promotion(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      expiryDate: map['expiryDate'] != null
          ? (map['expiryDate'] as Timestamp).toDate()
          : null,
    );
  }
}

class PromoProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Promotion> _promotions = [];
  bool _isLoading = false;
  String? _error;

  List<Promotion> get promotions => _promotions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPromotions() async {
    _setLoading(true);
    _setError(null);

    try {
      final now = DateTime.now();

      final promotionsSnapshot = await _firestore
          .collection('promotions')
          .where('expiryDate', isGreaterThan: Timestamp.fromDate(now))
          .get();

      _promotions = promotionsSnapshot.docs.map((doc) {
        return Promotion.fromMap(doc.id, doc.data());
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
