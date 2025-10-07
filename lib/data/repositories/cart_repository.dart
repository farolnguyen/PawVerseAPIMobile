import '../models/cart.dart';
import '../services/api_service.dart';
import '../../config/app_config.dart';

class CartRepository {
  final ApiService _api;

  CartRepository(this._api);

  // Get Cart
  Future<Cart> getCart() async {
    final response = await _api.get(AppConfig.cartEndpoint);
    
    return Cart.fromJson(response.data['data']);
  }

  // Add to Cart
  Future<Cart> addToCart(int sanPhamId, int soLuong) async {
    final response = await _api.post(
      '${AppConfig.cartEndpoint}/items',
      data: {
        'sanPhamId': sanPhamId,
        'soLuong': soLuong,
      },
    );

    return Cart.fromJson(response.data['data']);
  }

  // Update Cart Item Quantity
  Future<Cart> updateCartItem(int id, int soLuong) async {
    final response = await _api.put(
      '${AppConfig.cartEndpoint}/items/$id',
      data: {
        'soLuong': soLuong,
      },
    );

    return Cart.fromJson(response.data['data']);
  }

  // Remove Cart Item
  Future<Cart> removeCartItem(int id) async {
    final response = await _api.delete('${AppConfig.cartEndpoint}/items/$id');
    
    return Cart.fromJson(response.data['data']);
  }

  // Clear Cart
  Future<void> clearCart() async {
    await _api.delete('${AppConfig.cartEndpoint}/clear');
  }

  // Get Cart Count
  Future<int> getCartCount() async {
    final response = await _api.get('${AppConfig.cartEndpoint}/count');
    
    return response.data['data'];
  }
}
