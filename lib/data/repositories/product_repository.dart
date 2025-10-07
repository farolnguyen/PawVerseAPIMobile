import '../models/product.dart';
import '../services/api_service.dart';
import '../../config/app_config.dart';

class ProductRepository {
  final ApiService _api;

  ProductRepository(this._api);

  // Get Products with filters
  Future<List<Product>> getProducts({
    String? searchTerm,
    int? idDanhMuc,
    int? idThuongHieu,
    String? trangThai,
    double? giaMin,
    double? giaMax,
    bool? coKhuyenMai,
    bool? sanPhamMoi,
    bool? sanPhamBanChay,
    String? sortBy,
    String? sortOrder,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _api.get(
      AppConfig.productsEndpoint,
      queryParameters: {
        if (searchTerm != null) 'searchTerm': searchTerm,
        if (idDanhMuc != null) 'idDanhMuc': idDanhMuc,
        if (idThuongHieu != null) 'idThuongHieu': idThuongHieu,
        if (trangThai != null) 'trangThai': trangThai,
        if (giaMin != null) 'giaMin': giaMin,
        if (giaMax != null) 'giaMax': giaMax,
        if (coKhuyenMai != null) 'coKhuyenMai': coKhuyenMai,
        if (sanPhamMoi != null) 'sanPhamMoi': sanPhamMoi,
        if (sanPhamBanChay != null) 'sanPhamBanChay': sanPhamBanChay,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    final List<dynamic> items = response.data['data']['items'];
    return items.map((json) => Product.fromJson(json)).toList();
  }

  // Get Product by ID
  Future<Product> getProductById(int id) async {
    final response = await _api.get('${AppConfig.productsEndpoint}/$id');
    
    return Product.fromJson(response.data['data']);
  }

  // Get Categories
  Future<List<Category>> getCategories() async {
    final response = await _api.get(AppConfig.categoriesEndpoint);
    
    final List<dynamic> items = response.data['data'];
    return items.map((json) => Category.fromJson(json)).toList();
  }

  // Get Category by ID
  Future<Category> getCategoryById(int id) async {
    final response = await _api.get('${AppConfig.categoriesEndpoint}/$id');
    
    return Category.fromJson(response.data['data']);
  }

  // Get Brands
  Future<List<Brand>> getBrands() async {
    final response = await _api.get(AppConfig.brandsEndpoint);
    
    final List<dynamic> items = response.data['data'];
    return items.map((json) => Brand.fromJson(json)).toList();
  }

  // Get Brand by ID
  Future<Brand> getBrandById(int id) async {
    final response = await _api.get('${AppConfig.brandsEndpoint}/$id');
    
    return Brand.fromJson(response.data['data']);
  }
}
