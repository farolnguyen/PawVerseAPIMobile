import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              return Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  final product = productProvider.selectedProduct;
                  if (product == null) return const SizedBox.shrink();

                  final isInWishlist =
                      wishlistProvider.isInWishlist(product.idSanPham);

                  return IconButton(
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isInWishlist ? AppColors.error : null,
                    ),
                    onPressed: () async {
                      try {
                        await wishlistProvider.toggleWishlist(
                          product.idSanPham,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isInWishlist
                                    ? 'Đã xóa khỏi yêu thích'
                                    : 'Đã thêm vào yêu thích',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share product
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng đang phát triển')),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = productProvider.selectedProduct;
          if (product == null) {
            return const Center(child: Text('Không tìm thấy sản phẩm'));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Container(
                        height: 300,
                        color: AppColors.background,
                        child: Center(
                          child: product.hinhAnh != null &&
                                  product.hinhAnh!.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.pets,
                                      size: 100,
                                      color: AppColors.textSecondary,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.pets,
                                  size: 100,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              product.tenSanPham,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),

                            const SizedBox(height: 8),

                            // Brand & Category
                            Row(
                              children: [
                                if (product.tenThuongHieu != null) ...[
                                  const Icon(
                                    Icons.business,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.tenThuongHieu!,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                                if (product.tenDanhMuc != null) ...[
                                  const Icon(
                                    Icons.category,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.tenDanhMuc!,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Price
                            Row(
                              children: [
                                Text(
                                  currencyFormat.format(product.giaHienThi),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (product.coKhuyenMai) ...[
                                  Text(
                                    currencyFormat.format(product.giaBan),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.error,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '-${product.phanTramGiam?.toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Stock Status
                            Row(
                              children: [
                                Icon(
                                  product.conHang
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 20,
                                  color: product.conHang
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  product.conHang
                                      ? 'Còn hàng (${product.soLuongTonKho})'
                                      : 'Hết hàng',
                                  style: TextStyle(
                                    color: product.conHang
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),

                            // Product Details
                            Text(
                              'Thông tin sản phẩm',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),

                            if (product.trongLuong != null)
                              _buildInfoRow('Trọng lượng', product.trongLuong!),
                            if (product.mauSac != null)
                              _buildInfoRow('Màu sắc', product.mauSac!),
                            if (product.xuatXu != null)
                              _buildInfoRow('Xuất xứ', product.xuatXu!),

                            const SizedBox(height: 16),

                            // Description
                            if (product.moTa != null) ...[
                              Text(
                                'Mô tả',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.moTa!,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Bar
              Container(
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
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _quantity > 1
                                ? () {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            _quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: _quantity < product.soLuongTonKho
                                ? () {
                                    setState(() {
                                      _quantity++;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Add to Cart Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: product.conHang
                            ? () async {
                                try {
                                  await context
                                      .read<CartProvider>()
                                      .addToCart(
                                        product.idSanPham,
                                        _quantity,
                                      );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đã thêm vào giỏ hàng'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Thêm vào giỏ'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
