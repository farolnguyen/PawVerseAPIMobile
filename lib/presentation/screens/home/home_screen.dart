import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/filter_sort_bottom_sheet.dart';
import '../../widgets/badge_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    final productProvider = context.read<ProductProvider>();
    productProvider.loadProducts(refresh: true);
    productProvider.loadCategories();
    productProvider.loadBrands();
    context.read<CartProvider>().loadCart();
    context.read<WishlistProvider>().loadWishlist();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Schedule load in next frame to avoid "Build scheduled during frame" error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ProductProvider>().loadProducts();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          // Search Button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/search');
            },
          ),

          // Filter Button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FilterSortBottomSheet(),
              );
            },
          ),

          // Wishlist Button with Badge
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              return BadgeIcon(
                icon: Icons.favorite_border,
                count: wishlistProvider.itemCount,
                onPressed: () => context.push('/wishlist'),
                tooltip: 'Danh sách yêu thích',
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProductProvider>().loadProducts(refresh: true);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // User Greeting
            SliverToBoxAdapter(
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.user;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    color: AppColors.primary.withOpacity(0.1),
                    child: Row(
                      children: [
                        CircleAvatar(
                          key: ValueKey(user?.avatar ?? 'no-avatar'),
                          backgroundColor: AppColors.primary,
                          backgroundImage: user?.avatar != null && user!.avatar!.isNotEmpty
                              ? NetworkImage(
                                  '${AppConfig.getImageUrl(user.avatar!)}?t=${DateTime.now().millisecondsSinceEpoch}',
                                )
                              : null,
                          child: user?.avatar == null || user!.avatar!.isEmpty
                              ? Text(
                                  user?.initials ?? '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Xin chào,',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                user?.displayName ?? 'Guest',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.categories.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Danh mục',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/categories');
                              },
                              child: const Text('Xem tất cả'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: productProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = productProvider.categories[index];
                            final isSelected = productProvider
                                    .selectedCategoryId ==
                                category.idDanhMuc;

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  productProvider.filterByCategory(
                                    isSelected ? null : category.idDanhMuc,
                                  );
                                },
                                child: Container(
                                  width: 95,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Category Image/Icon
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white.withOpacity(0.2)
                                              : AppColors.primary.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: category.hinhAnh != null
                                            ? ClipOval(
                                                child: Image.network(
                                                  AppConfig.getImageUrl(category.hinhAnh),
                                                  width: 48,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(
                                                      Icons.category,
                                                      size: 24,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : AppColors.primary,
                                                    );
                                                  },
                                                ),
                                              )
                                            : Icon(
                                                Icons.category,
                                                size: 24,
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.primary,
                                              ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        category.tenDanhMuc,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),

            // Products Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _showSortDialog();
                      },
                      icon: const Icon(Icons.sort),
                      label: const Text('Sắp xếp'),
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.products.isEmpty &&
                    productProvider.isLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (productProvider.products.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('Không có sản phẩm nào'),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = productProvider.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            context.push(
                              '/product-detail',
                              extra: product.idSanPham,
                            );
                          },
                        );
                      },
                      childCount: productProvider.products.length,
                    ),
                  ),
                );
              },
            ),

            // Loading More Indicator
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading &&
                    productProvider.products.isNotEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Mới nhất'),
              onTap: () {
                context.read<ProductProvider>().setSorting('ngayTao', 'desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Bán chạy'),
              onTap: () {
                context
                    .read<ProductProvider>()
                    .setSorting('soLuongDaBan', 'desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text('Giá tăng dần'),
              onTap: () {
                context.read<ProductProvider>().setSorting('giaBan', 'asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text('Giá giảm dần'),
              onTap: () {
                context.read<ProductProvider>().setSorting('giaBan', 'desc');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
