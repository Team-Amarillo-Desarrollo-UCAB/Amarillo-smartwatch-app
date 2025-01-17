import 'package:flutter/material.dart';
import 'package:watch_app/common/presentation/color_extension.dart';
import 'package:wear/wear.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../login/infrastructure/login_service.dart';
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
  List<String> status = ['CREATED'];
  final token = await _authService.getToken();
  
  // Convertir la lista de status en una cadena separada por comas
  String statusParam = status.join(',');

  // Construir la URL correctamente
  String url = 'https://amarillo-backend-production.up.railway.app/order/many?status=$statusParam';

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

//   Future<List<Order>> fetchOrders() async {
//   final status = ['CREATED'];
//   final token = await _authService.getToken();

//   // Convertir la lista de status en una cadena separada por comas
//   String statusParam = status.join(',');

//   // Construir la URL correctamente
//   String url = 'https://amarillo-backend-production.up.railway.app/order/many?status=$statusParam';

//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       'Authorization': 'Bearer $token',
//     },
//   );

//   print("response: ${response.body}");

//   if (response.statusCode == 200) {
//     final List<dynamic> ordersJson = json.decode(response.body);
//     return ordersJson.map((json) => Order.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load orders');
//   }
// }


  // @override
  // Widget build(BuildContext context) {
  //   return WatchShape(
  //     builder: (context, shape, child) {
  //       // Get the screen size
  //       final screenSize = MediaQuery.of(context).size;
  //       final radius = screenSize.width / 2;
        
  //       return AmbientMode(
  //         builder: (context, mode, child) {
  //           return Scaffold(
  //             backgroundColor: Colors.black,
  //             body: SafeArea(
  //               child: FutureBuilder<List<Order>>(
  //                 future: _ordersFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return _buildLoadingState();
  //                   } else if (snapshot.hasError) {
  //                     return _buildErrorState(snapshot.error.toString());
  //                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //                     return _buildEmptyState();
  //                   }
  //                   return _buildOrdersList(snapshot.data!, shape == WearShape.round ? radius : null);
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Órdenes',
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
            MaterialPageRoute(builder: (context) => const OrderStatusScreen()),
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


class OrderData {
  final String id;
  final String orderState;
  final DateTime orderCreatedDate;
  final String totalAmount;
  final String subTotal;
  final String shippingFee;
  final String currency;
  final double latitude;
  final double longitude;
  final String directionName;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> bundles;
  final String orderReport;
  final Map<String, dynamic> orderPayment;
  final String orderDiscount;

  OrderData({
    required this.id,
    required this.orderState,
    required this.orderCreatedDate,
    required this.totalAmount,
    required this.subTotal,
    required this.shippingFee,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.directionName,
    required this.products,
    required this.bundles,
    required this.orderReport,
    required this.orderPayment,
    required this.orderDiscount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id']?? 'ERROR01',
      orderState: json['orderState'] ?? ' ',
      orderCreatedDate: json['orderCreatedDate'] != null ? DateTime.parse(json['orderCreatedDate']) : DateTime.now(),
      totalAmount: (json['totalAmount'] ?? 0.0).toString(),
      subTotal: (json['sub_total'] ?? 0.0).toString(),
      shippingFee: (json['shipping_fee'] ?? 0.0).toString(),
      currency: json['currency'] ?? 'USD',
      latitude:(json['orderDirection']['lat']) ?? 0.0,
      longitude: (json['orderDirection']['long']) ?? 0.0,
      directionName: json['directionName'] ?? ' ',
      products: List<Map<String, dynamic>>.from(json['products'] ?? []),
      bundles: List<Map<String, dynamic>>.from(json['bundles'] ?? []),
      orderReport: json['orderReport'] ?? ' ',
      orderPayment: Map<String, dynamic>.from(json['orderPayment'] ?? {}),
      orderDiscount: (json['orderDiscount'] ?? 0.0).toString(),
    );
  }
}
