// screens/order_details_screen.dart
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order on ${order.date}')),
      body: ListView.builder(
        itemCount: order.items.length,
        itemBuilder: (context, index) {
          final item = order.items[index];
          return ListTile(
            leading: Image.asset(item.product.image, width: 50),
            title: Text(item.product.name),
            subtitle: Text(
              'Price: \$${item.product.price} | Quantity: ${item.quantity}',
            ),
            trailing: Text(
              'Subtotal: \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total: \$${order.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}
