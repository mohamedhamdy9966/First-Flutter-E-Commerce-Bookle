import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../utils/storage.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cart = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final loadedCart = await Storage.getCart();
    setState(() => cart = loadedCart);
  }

  double get totalPrice =>
      cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  Future<void> _updateCart() async {
    await Storage.saveCart(cart);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  leading: Image.asset(item.product.image, width: 50),
                  title: Text(item.product.name),
                  subtitle: Text(
                    'Price: \$${item.product.price.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () async {
                          if (item.quantity > 1) {
                            setState(() => item.quantity--);
                          } else {
                            setState(() => cart.removeAt(index));
                          }
                          await _updateCart();
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          setState(() => item.quantity++);
                          await _updateCart();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          setState(() => cart.removeAt(index));
                          await _updateCart();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final orders = await Storage.getOrders();
                      orders.add(
                        Order(
                          items: List.from(cart),
                          totalPrice: totalPrice,
                          date: DateTime.now().toString(),
                        ),
                      );
                      await Storage.saveOrders(orders);
                      await Storage.saveCart([]);
                      setState(() => cart = []);
                      Navigator.pushNamed(context, '/orders');
                    },
                    child: const Text('Place Order'),
                  ),
                ],
              ),
            ),
    );
  }
}
