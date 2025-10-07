import '../models/wishlist.dart';
import '../services/api_service.dart';
import '../../config/app_config.dart';

class WishlistRepository {
  final ApiService _api;

  WishlistRepository(this._api);

  // Get Wishlist
  Future<List<WishlistItem>> getWishlist() async {
    final response = await _api.get(AppConfig.wishlistEndpoint);
    
    final List<dynamic> items = response.data['data'];
    return items.map((json) => WishlistItem.fromJson(json)).toList();
  }

  // Add to Wishlist
  Future<WishlistItem> addToWishlist(int idSanPham) async {
    final response = await _api.post(
      AppConfig.wishlistEndpoint,
      data: {
        'idSanPham': idSanPham,
      },
    );

    return WishlistItem.fromJson(response.data['data']);
  }

  // Remove from Wishlist by Wishlist ID
  Future<void> removeFromWishlist(int id) async {
    await _api.delete('${AppConfig.wishlistEndpoint}/$id');
  }

  // Remove from Wishlist by Product ID
  Future<void> removeFromWishlistByProductId(int productId) async {
    await _api.delete('${AppConfig.wishlistEndpoint}/product/$productId');
  }

  // Check if Product in Wishlist
  Future<bool> checkInWishlist(int productId) async {
    final response = await _api.get('${AppConfig.wishlistEndpoint}/check/$productId');
    
    return response.data['data'];
  }

  // Get Wishlist Count
  Future<int> getWishlistCount() async {
    final response = await _api.get('${AppConfig.wishlistEndpoint}/count');
    
    return response.data['data'];
  }

  // Clear Wishlist
  Future<void> clearWishlist() async {
    await _api.delete('${AppConfig.wishlistEndpoint}/clear');
  }
}
