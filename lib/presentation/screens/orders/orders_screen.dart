import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/order.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/order_card_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String?>> _tabs = [
    {'label': 'Tất cả', 'status': null},
    {'label': 'Chờ xác nhận', 'status': 'Chờ xác nhận'},
    {'label': 'Đã xác nhận', 'status': 'Đã xác nhận'},
    {'label': 'Đang giao', 'status': 'Đang giao'}, // Match database exactly
    {'label': 'Đã giao', 'status': 'Đã giao'}, // Match database exactly
    {'label': 'Đã hủy', 'status': 'Đã hủy'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    
    // Load initial orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final status = _tabs[_tabController.index]['status'];
      context.read<OrderProvider>().filterByStatus(status);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      // Schedule load in next frame to avoid "Build scheduled during frame" error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<OrderProvider>().loadOrders();
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    await context.read<OrderProvider>().loadOrders(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab['label'])).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => _buildOrdersList(tab['status'])).toList(),
      ),
    );
  }

  Widget _buildOrdersList(String? status) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final orders = status == null 
            ? orderProvider.orders 
            : orderProvider.getOrdersByStatus(status);

        if (orderProvider.isLoading && orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderProvider.error != null && orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lỗi tải đơn hàng',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  orderProvider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onRefresh,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (orders.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.shopping_bag_outlined,
            title: 'Chưa có đơn hàng',
            message: 'Bạn chưa có đơn hàng nào',
            buttonText: 'Bắt đầu mua sắm',
            onButtonPressed: () => context.go('/home'),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: orders.length + (orderProvider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == orders.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final order = orders[index];
              return OrderCardWidget(
                order: order,
                onTap: () => context.push('/orders/${order.idDonHang}'),
                onCancel: order.canCancel ? () => _showCancelDialog(order) : null,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showCancelDialog(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: Text('Bạn có chắc muốn hủy đơn hàng #${order.idDonHang}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<OrderProvider>().cancelOrder(order.idDonHang);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã hủy đơn hàng thành công'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
