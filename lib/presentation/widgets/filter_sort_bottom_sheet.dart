import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../data/models/product.dart';

class FilterSortBottomSheet extends StatefulWidget {
  const FilterSortBottomSheet({super.key});

  @override
  State<FilterSortBottomSheet> createState() => _FilterSortBottomSheetState();
}

class _FilterSortBottomSheetState extends State<FilterSortBottomSheet> {
  // Filter states
  Set<int> _selectedCategories = {};
  Set<int> _selectedBrands = {};
  double? _minPrice;
  double? _maxPrice;
  String _sortBy = 'ngayTao';
  String _sortOrder = 'desc';

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _loadCurrentFilters() {
    final productProvider = context.read<ProductProvider>();
    
    if (productProvider.selectedCategoryId != null) {
      _selectedCategories.add(productProvider.selectedCategoryId!);
    }
    
    if (productProvider.selectedBrandId != null) {
      _selectedBrands.add(productProvider.selectedBrandId!);
    }
  }

  void _applyFilters() {
    final productProvider = context.read<ProductProvider>();

    // Apply category filter (only support single category for now)
    if (_selectedCategories.isNotEmpty) {
      productProvider.filterByCategory(_selectedCategories.first);
    } else {
      productProvider.filterByCategory(null);
    }

    // Apply brand filter (only support single brand for now)
    if (_selectedBrands.isNotEmpty) {
      productProvider.filterByBrand(_selectedBrands.first);
    } else {
      productProvider.filterByBrand(null);
    }

    // Apply sorting
    productProvider.setSorting(_sortBy, _sortOrder);

    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedBrands.clear();
      _minPrice = null;
      _maxPrice = null;
      _minPriceController.clear();
      _maxPriceController.clear();
      _sortBy = 'ngayTao';
      _sortOrder = 'desc';
    });

    context.read<ProductProvider>().clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(),
              const Divider(height: 1),
              
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildCategoryFilter(),
                    const SizedBox(height: 24),
                    _buildBrandFilter(),
                    const SizedBox(height: 24),
                    _buildPriceFilter(),
                    const SizedBox(height: 24),
                    _buildSortOptions(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              
              // Footer with buttons
              _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Lọc & Sắp xếp',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final categories = productProvider.categories;

        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh mục',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final isSelected = _selectedCategories.contains(category.idDanhMuc);
                
                return FilterChip(
                  label: Text(category.tenDanhMuc),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.clear(); // Single select
                        _selectedCategories.add(category.idDanhMuc);
                      } else {
                        _selectedCategories.remove(category.idDanhMuc);
                      }
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBrandFilter() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final brands = productProvider.brands;

        if (brands.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thương hiệu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: brands.map((brand) {
                final isSelected = _selectedBrands.contains(brand.idThuongHieu);
                
                return FilterChip(
                  label: Text(brand.tenThuongHieu),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedBrands.clear(); // Single select
                        _selectedBrands.add(brand.idThuongHieu);
                      } else {
                        _selectedBrands.remove(brand.idThuongHieu);
                      }
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Khoảng giá',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Quick price filters
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPriceChip('Dưới 100k', 0, 100000),
            _buildPriceChip('100k - 500k', 100000, 500000),
            _buildPriceChip('500k - 1tr', 500000, 1000000),
            _buildPriceChip('Trên 1tr', 1000000, null),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Custom price range
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá tối thiểu',
                  border: OutlineInputBorder(),
                  suffixText: '₫',
                ),
                onChanged: (value) {
                  setState(() {
                    _minPrice = double.tryParse(value);
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('—'),
            ),
            Expanded(
              child: TextField(
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá tối đa',
                  border: OutlineInputBorder(),
                  suffixText: '₫',
                ),
                onChanged: (value) {
                  setState(() {
                    _maxPrice = double.tryParse(value);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceChip(String label, double? min, double? max) {
    final isSelected = _minPrice == min && _maxPrice == max;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _minPrice = min;
            _maxPrice = max;
            _minPriceController.text = min?.toString() ?? '';
            _maxPriceController.text = max?.toString() ?? '';
          } else {
            _minPrice = null;
            _maxPrice = null;
            _minPriceController.clear();
            _maxPriceController.clear();
          }
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildSortOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sắp xếp',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildSortOption(
          'Mới nhất',
          'ngayTao',
          'desc',
          Icons.access_time,
        ),
        _buildSortOption(
          'Giá thấp đến cao',
          'giaBan',
          'asc',
          Icons.arrow_upward,
        ),
        _buildSortOption(
          'Giá cao đến thấp',
          'giaBan',
          'desc',
          Icons.arrow_downward,
        ),
        _buildSortOption(
          'Tên A-Z',
          'tenSanPham',
          'asc',
          Icons.sort_by_alpha,
        ),
      ],
    );
  }

  Widget _buildSortOption(
    String label,
    String sortBy,
    String sortOrder,
    IconData icon,
  ) {
    final isSelected = _sortBy == sortBy && _sortOrder == sortOrder;
    
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      value: '$sortBy-$sortOrder',
      groupValue: '${_sortBy}-${_sortOrder}',
      onChanged: (value) {
        setState(() {
          _sortBy = sortBy;
          _sortOrder = sortOrder;
        });
      },
      activeColor: AppColors.primary,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Xóa bộ lọc'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Áp dụng'),
            ),
          ),
        ],
      ),
    );
  }
}
