import 'package:flutter/material.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  // State
  List<Product> _products = [];
  List<Category> _categories = [];
  List<Brand> _brands = [];
  Product? _selectedProduct;
  
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  
  // Filters
  String? _searchTerm;
  int? _selectedCategoryId;
  int? _selectedBrandId;
  String _sortBy = 'ngayTao';
  String _sortOrder = 'desc';
  int _currentPage = 1;
  final int _pageSize = 20;

  // Getters
  List<Product> get products => _products;
  List<Category> get categories => _categories;
  List<Brand> get brands => _brands;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String? get searchTerm => _searchTerm;
  int? get selectedCategoryId => _selectedCategoryId;
  int? get selectedBrandId => _selectedBrandId;

  // Load Products
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _products = [];
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newProducts = await _repository.getProducts(
        searchTerm: _searchTerm,
        idDanhMuc: _selectedCategoryId,
        idThuongHieu: _selectedBrandId,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        pageNumber: _currentPage,
        pageSize: _pageSize,
      );

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load Categories
  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getCategories();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load Brands
  Future<void> loadBrands() async {
    try {
      _brands = await _repository.getBrands();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get Product by ID
  Future<void> loadProductById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProduct = await _repository.getProductById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search
  void setSearchTerm(String? term) {
    _searchTerm = term;
    loadProducts(refresh: true);
  }

  // Filter by Category
  void filterByCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    loadProducts(refresh: true);
  }

  // Filter by Brand
  void filterByBrand(int? brandId) {
    _selectedBrandId = brandId;
    loadProducts(refresh: true);
  }

  // Sort
  void setSorting(String sortBy, String sortOrder) {
    _sortBy = sortBy;
    _sortOrder = sortOrder;
    loadProducts(refresh: true);
  }

  // Clear Filters
  void clearFilters() {
    _searchTerm = null;
    _selectedCategoryId = null;
    _selectedBrandId = null;
    _sortBy = 'ngayTao';
    _sortOrder = 'desc';
    loadProducts(refresh: true);
  }

  // Clear Error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
