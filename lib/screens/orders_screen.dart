import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/storage.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    final loadedOrders = await Storage.getOrders();
    setState(() => orders = loadedOrders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: ListTile(
              title: Text('Order on ${order.date}'),
              subtitle: Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
              trailing: Text('${order.items.length} items'),
              onTap: () {
                // Optionally show order details
              },
            ),
          );
        },
      ),
    );
  }
}
