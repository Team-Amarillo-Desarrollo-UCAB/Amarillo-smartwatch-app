import 'package:flutter/material.dart';
import 'package:wear/wear.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../login/infrastructure/login_service.dart';

class Order {
  final String id;
  final String status;
  final double total;
  final String date;

  Order({
    required this.id,
    required this.status,
    required this.total,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      total: (json['total'] ?? 0.0).toDouble(),
      date: json['date'] ?? '',
    );
  }
}

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  Future<List<Order>>? _ordersFuture;
  final ScrollController _scrollController = ScrollController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Order>> fetchOrders() async {
    final token = await _authService.getToken(); 
    final url = Uri.parse('https://amarillo-backend-production.up.railway.app/order/many');
    final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    if (response.statusCode == 200) {
      final List<dynamic> ordersJson = json.decode(response.body);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        // Get the screen size
        final screenSize = MediaQuery.of(context).size;
        final radius = screenSize.width / 2;
        
        return AmbientMode(
          builder: (context, mode, child) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: FutureBuilder<List<Order>>(
                  future: _ordersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState();
                    } else if (snapshot.hasError) {
                      return _buildErrorState(snapshot.error.toString());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildOrdersList(snapshot.data!, shape == WearShape.round ? radius : null);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error: $error',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No orders found',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders, double? radius) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Orders list',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            // This enables the scrollbar for the watch
            behavior: ScrollBehavior(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                // If we have a radius (round watch), clip the list items
                if (radius != null) {
                  return ClipPath(
                    clipper: WatchShapeClipper(
                      shape: WearShape.round,
                      radius: radius,
                    ),
                    child: _buildOrderItem(order),
                  );
                }
                return _buildOrderItem(order);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade900,
            Colors.purple.shade900,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 4.0,
        ),
        title: Text(
          'Order #${order.id}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${order.status}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Text(
              '\$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          // Handle order tap
        },
      ),
    );
  }
}

class WatchShapeClipper extends CustomClipper<Path> {
  final WearShape shape;
  final double radius;

  WatchShapeClipper({
    required this.shape,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    if (shape == WearShape.round) {
      final center = Offset(size.width / 2, size.height / 2);
      final path = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius));
      return path;
    }
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}