import 'package:flutter/material.dart';
import 'package:watch_app/common/presentation/color_extension.dart';
import 'package:wear/wear.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Users/presentation/profile_screen.dart';
import '../../login/infrastructure/login_service.dart';
import '../domain/orderData.dart';
import 'order_detailed.dart';

class Order {
  final String id;
  final String status;
  final String total;
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
      status: json['orderState'] ?? '',
      total: (json['totalAmount'] ?? 0.0).toDouble(),
      date: json['orderCreatedDate'] ?? '',
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
  List<String> status = ["CREATED", "BEING PROCESSED", "SHIPPED"];
  final token = await _authService.getToken();
  // Convertir la lista de status en una cadena separada por comas
  String statusParam = status.join(',');

  // Construir la URL correctamente
  String url = 'https://amarillo-backend-production.up.railway.app/order/many?perpage=40';

  for (var s in status) {
    url += '&status=$s';
  }

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print("Código de respuesta: ${response.statusCode}"); // Debug

  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedData = json.decode(response.body);

    final List<dynamic> orders = decodedData['orders'];

    return orders.map((json) {
      final orderData = OrderData.fromJson(json);
      return Order(
        id: orderData.id,
        status: orderData.orderState,
        total: orderData.totalAmount,
        date: orderData.orderCreatedDate.toString(),
      );
    }).toList();
  } else {
    throw Exception('Error al obtener las órdenes con backend amarillo');
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
              child: Stack(
                children: [
                  // Imagen de fondo
                  Positioned.fill(
                    child: Image.asset(
                      'assets/img/fondoWear.png', // Ruta de tu imagen
                      fit: BoxFit.cover, // Ajuste de la imagen
                    ),
                  ),
                  // Contenido principal
                  FutureBuilder<List<Order>>(
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
                ],
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
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Órdenes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.person, // Ícono de usuario
                color: Colors.white,
              ),
              onPressed: () {
                // Navegación a otra vista
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(), // Cambia por tu pantalla de destino
                  ),
                );
              },
            ),
          ],
        ),
      ),
      Expanded(
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
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
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.primary,
            TColor.secondary,
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
          'Order #${order.id.substring(order.id.length - 4)}',
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
              '\$${order.total}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderStatusWatch(orderId: order.id,)),
          );
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
