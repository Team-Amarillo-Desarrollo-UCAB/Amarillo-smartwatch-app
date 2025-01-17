// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:wear/wear.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math' as math;
// import '../../common/infrastructure/tokenUser.dart';
// import '../domain/orderData.dart';

// class OrderStatusWatch extends StatefulWidget {
//   final String orderId;
  
//   const OrderStatusWatch({
//     Key? key,
//     required this.orderId,
//   }) : super(key: key);

//   @override
//   State<OrderStatusWatch> createState() => _OrderStatusWatchState();
// }

// class _OrderStatusWatchState extends State<OrderStatusWatch> {
//   Future<Order>? _orderFuture;
//   Order? _currentOrder;
//   late Timer _timer;

//   @override
//   @override
// void initState() {
//   super.initState();
//   // Cargar la orden inicial
//   _fetchOrder();

//   // Inicia el temporizador para actualizar los datos cada 5 segundos
//   _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//     if (mounted) {
//       _fetchOrder();
//     } else {
//       timer.cancel();
//     }
//   });
// }

//   void _fetchOrder() async {
//   try {
//     final order = await getOrderById(widget.orderId);
//     if (mounted) {
//       setState(() {
//         _currentOrder = order;
//       });
//     }
//   } catch (e) {
//     // Manejo de errores (opcional)
//     print('Error al cargar la orden: $e');
//   }
// }

// @override
// void dispose() {
//   // Cancela el temporizador cuando el widget se desmonte
//   _timer.cancel();
//   super.dispose();
// }

//  Future<Order> getOrderById(String orderId) async {
//     print("OrderID" + orderId);
//     final token = await TokenUser().getToken();
//         final response =
//             await http.get(
//               Uri.parse('https://amarillo-backend-production.up.railway.app/order/one/$orderId'),
//               headers: {
//                 'Authorization': 'Bearer $token',
//               }
//               );// Debug
//         if (response.statusCode == 200) {
//           final Map<String, dynamic> data = json.decode(response.body);

//           final orderData = OrderData.fromJson(data);

//           return Order(
//             orderId: orderData.id,
//             latitude: orderData.latitude,
//             longitude: orderData.longitude,
//             directionName: orderData.directionName,
//             status: orderData.orderState,
//           );
//         }
//         else {
//           throw Exception('Error al cargar la orden');
//         }
//     } 

//   @override
// Widget build(BuildContext context) {
//   return WatchShape(
//     builder: (context, shape, child) {
//       return AmbientMode(
//         builder: (context, mode, child) {
//           return Scaffold(
//             backgroundColor: Colors.black,
//             body: Stack(
//               children: [
//                 // Background
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/img/fondoWear.png'), // Ruta de la imagen
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),

//                 // Content
//                 FutureBuilder<Order>(
//                   future: _orderFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                       );
//                     }

//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text(
//                           'Error: ${snapshot.error}',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       );
//                     }

//                     if (!snapshot.hasData) {
//                       return const Center(
//                         child: Text(
//                           'No order found',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       );
//                     }

//                     final order = snapshot.data!;
//                     final lastFourChars = "Orden \n " +
//                         order.orderId.substring(
//                           math.max(0, order.orderId.length - 4),
//                         );

//                     return LayoutBuilder(
//                       builder: (context, constraints) {
//                         final size = constraints.maxWidth;
//                         return Stack(
//                           children: [
//                             // Order ID (Center)
//                             Positioned(
//                               left: 0,
//                               top: size * 0.35,
//                               right: size * 0.42,
//                               height: size * 0.3,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     lastFourChars,
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             // Created State (Top)
//                             Positioned(
//                               left: 0,
//                               top: size * 0.1,
//                               width: size * 0.5,
//                               height: size * 0.2,
//                               child: _buildStateIndicator(
//                                 "CREADA",
//                                 order.status == "CREATED",
//                                 Colors.blue,
//                               ),
//                             ),

//                             // Processing State (Right)
//                             Positioned(
//                               right: size * 0.01,
//                               top: size * 0.1,
//                               width: size * 0.5,
//                               height: size * 0.2,
//                               child: _buildStateIndicator(
//                                 "EN PROCESO",
//                                 order.status == "BEING_PROCESSED",
//                                 Colors.orange,
//                               ),
//                             ),

//                             Positioned(
//                               right: 0,
//                               top: size * 0.35,
//                               width: size * 0.4,
//                               height: size * 0.3,
//                               child: _buildStateIndicator(
//                                 "EN CAMINO",
//                                 order.status == "SHIPPED",
//                                 Colors.orange,
//                               ),
//                             ),

//                             // Shipped State (Bottom)
//                             Positioned(
//                               left: size * 0.15,
//                               bottom: size * 0.05,
//                               width: size * 0.80,
//                               height: size * 0.24,
//                               child: _buildStateIndicator(
//                                 "COMPLETADA",
//                                 order.status == "DELIVERED",
//                                 Colors.green,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

//   Widget _buildStateIndicator(String state, bool isActive, Color activeColor) {
//     return Container(
//       margin: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: isActive ? activeColor : const Color.fromARGB(247, 196, 196, 196),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(
//           state,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isActive ? Colors.white : const Color.fromARGB(211, 0, 0, 0),
//             fontSize: 12,
//             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Order Model
// class Order {
//   final String orderId;
//   final double latitude;
//   final double longitude;
//   final String directionName;
//   final String status;


//   Order({
//     required this.orderId,
//     required this.latitude,
//     required this.longitude,
//     required this.directionName,
//     required this.status,
//   });
// }

import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../../common/infrastructure/tokenUser.dart';
import '../domain/orderData.dart';

class OrderStatusWatch extends StatefulWidget {
  final String orderId;

  const OrderStatusWatch({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderStatusWatch> createState() => _OrderStatusWatchState();
}

class _OrderStatusWatchState extends State<OrderStatusWatch> {
  Order? _currentOrder;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Cargar la orden inicial
    _fetchOrder();

    // Inicia el temporizador para actualizar los datos cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _fetchOrder();
      } else {
        timer.cancel();
      }
    });
  }

  void _fetchOrder() async {
    try {
      final order = await getOrderById(widget.orderId);
      if (mounted) {
        setState(() {
          _currentOrder = order;
        });
      }
    } catch (e) {
      // Manejo de errores (opcional)
      print('Error al cargar la orden: $e');
    }
  }

  @override
  void dispose() {
    // Cancela el temporizador cuando el widget se desmonte
    _timer.cancel();
    super.dispose();
  }

  Future<Order> getOrderById(String orderId) async {
    print("OrderID" + orderId);
    final token = await TokenUser().getToken();
    final response = await http.get(
      Uri.parse('https://amarillo-backend-production.up.railway.app/order/one/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final orderData = OrderData.fromJson(data);

      return Order(
        orderId: orderData.id,
        latitude: orderData.latitude,
        longitude: orderData.longitude,
        directionName: orderData.directionName,
        status: orderData.orderState,
      );
    } else {
      throw Exception('Error al cargar la orden');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  // Background
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/fondoWear.png'), // Ruta de la imagen
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Content
                  _currentOrder == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : _buildOrderContent(_currentOrder!),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderContent(Order order) {
    final lastFourChars = "Orden \n " +
        order.orderId.substring(
          math.max(0, order.orderId.length - 4),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return Stack(
          children: [
            // Order ID (Center)
            Positioned(
              left: 0,
              top: size * 0.35,
              right: size * 0.42,
              height: size * 0.3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    lastFourChars,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Created State (Top)
            Positioned(
              left: 0,
              top: size * 0.1,
              width: size * 0.5,
              height: size * 0.2,
              child: _buildStateIndicator(
                "CREADA",
                order.status == "CREATED",
                Colors.blue,
              ),
            ),

            // Processing State (Right)
            Positioned(
              right: size * 0.01,
              top: size * 0.1,
              width: size * 0.5,
              height: size * 0.2,
              child: _buildStateIndicator(
                "EN PROCESO",
                order.status == "BEING_PROCESSED",
                Colors.orange,
              ),
            ),

            Positioned(
              right: 0,
              top: size * 0.35,
              width: size * 0.4,
              height: size * 0.3,
              child: _buildStateIndicator(
                "EN CAMINO",
                order.status == "SHIPPED",
                Colors.orange,
              ),
            ),

            // Shipped State (Bottom)
            Positioned(
              left: size * 0.15,
              bottom: size * 0.05,
              width: size * 0.80,
              height: size * 0.24,
              child: _buildStateIndicator(
                "COMPLETADA",
                order.status == "DELIVERED",
                Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStateIndicator(String state, bool isActive, Color activeColor) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isActive ? activeColor : const Color.fromARGB(247, 196, 196, 196),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          state,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : const Color.fromARGB(211, 0, 0, 0),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Order Model
class Order {
  final String orderId;
  final double latitude;
  final double longitude;
  final String directionName;
  final String status;

  Order({
    required this.orderId,
    required this.latitude,
    required this.longitude,
    required this.directionName,
    required this.status,
  });
}
