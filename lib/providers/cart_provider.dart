import 'package:flutter/material.dart';
import '../data/models/cart.dart';
import '../data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartProvider(this._repository);

  Cart _cart = Cart.empty();
  bool _isLoading = false;
  String? _error;

  // Getters
  Cart get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _cart.tongSoLuong;
  double get total => _cart.tongTien;

  // Load Cart
  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _repository.getCart();
    } catch (e) {
      _error = e.toString();
      _cart = Cart.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to Cart
  Future<void> addToCart(int productId, int quantity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _repository.addToCart(productId, quantity);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Quantity
  Future<void> updateQuantity(int itemId, int quantity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _repository.updateCartItem(itemId, quantity);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove Item
  Future<void> removeItem(int itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _repository.removeCartItem(itemId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear Cart
  Future<void> clearCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.clearCart();
      _cart = Cart.empty();
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
