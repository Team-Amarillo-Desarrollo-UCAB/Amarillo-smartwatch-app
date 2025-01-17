import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        // Mock data
        const String orderId = "A1B2C3";
        const List<OrderState> states = [
          OrderState("Created", true),
          OrderState("Processing", false),
          OrderState("Shipping", false),
          OrderState("Delivered", false),
        ];

        return AmbientMode(
          builder: (context, mode, child) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth;
                      return Stack(
                        children: [
                          // Center Order ID
                          Positioned(
                            left: size * 0.2,
                            top: size * 0.3,
                            right: size * 0.2,
                            bottom: size * 0.3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  orderId,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Top Left State
                          Positioned(
                            left: 0,
                            top: 0,
                            width: size * 0.45,
                            height: size * 0.45,
                            child: _buildStateBox(
                              states[0],
                              Colors.blue,
                              Colors.grey,
                            ),
                          ),
                          // Top Right State
                          Positioned(
                            right: 0,
                            top: 0,
                            width: size * 0.35,
                            height: size * 0.35,
                            child: _buildStateBox(
                              states[1],
                              Colors.orange,
                              Colors.grey,
                            ),
                          ),
                          // Bottom Left State
                          Positioned(
                            left: 0,
                            bottom: 0,
                            width: size * 0.35,
                            height: size * 0.35,
                            child: _buildStateBox(
                              states[2],
                              Colors.green,
                              Colors.grey,
                            ),
                          ),
                          // Bottom Right State
                          Positioned(
                            right: 0,
                            bottom: 0,
                            width: size * 0.45,
                            height: size * 0.45,
                            child: _buildStateBox(
                              states[3],
                              Colors.red,
                              Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStateBox(OrderState state, Color activeColor, Color inactiveColor) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: state.isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.name,
            style: TextStyle(
              color: state.isActive ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OrderState {
  final String name;
  final bool isActive;

  const OrderState(this.name, this.isActive);
}

// Example usage
void main() {
  runApp(
    MaterialApp(
      home: const OrderStatusScreen(),
      theme: ThemeData.dark(),
    ),
  );
}