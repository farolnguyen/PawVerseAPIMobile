import 'package:flutter/material.dart';
import '../data/models/wishlist.dart';
import '../data/repositories/wishlist_repository.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository _repository;

  WishlistProvider(this._repository);

  List<WishlistItem> _items = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<WishlistItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;

  // Load Wishlist
  Future<void> loadWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repository.getWishlist();
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to Wishlist
  Future<void> addToWishlist(int productId) async {
    try {
      final item = await _repository.addToWishlist(productId);
      _items.insert(0, item);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Remove from Wishlist
  Future<void> removeFromWishlist(int wishlistId) async {
    try {
      await _repository.removeFromWishlist(wishlistId);
      _items.removeWhere((item) => item.idYeuThich == wishlistId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Remove by Product ID
  Future<void> removeByProductId(int productId) async {
    try {
      await _repository.removeFromWishlistByProductId(productId);
      _items.removeWhere((item) => item.idSanPham == productId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Check if in Wishlist
  bool isInWishlist(int productId) {
    return _items.any((item) => item.idSanPham == productId);
  }

  // Toggle Wishlist
  Future<void> toggleWishlist(int productId) async {
    if (isInWishlist(productId)) {
      await removeByProductId(productId);
    } else {
      await addToWishlist(productId);
    }
  }

  // Clear Wishlist
  Future<void> clearWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.clearWishlist();
      _items = [];
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear Error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
