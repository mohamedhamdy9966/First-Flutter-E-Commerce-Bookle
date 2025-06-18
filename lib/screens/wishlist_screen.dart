import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/storage.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<CartItem> wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  void _loadWishlist() async {
    final savedWishlist = await Storage.getWishlist();
    setState(() => wishlist = savedWishlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Your wishlist is empty."),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text("Go to Home"),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final item = wishlist[index];
                return ListTile(
                  leading: Image.asset(item.product.image, width: 50),
                  title: Text(item.product.name),
                  subtitle: Text('Price: \$${item.product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      setState(() => wishlist.removeAt(index));
                      await Storage.saveWishlist(wishlist);
                    },
                  ),
                );
              },
            ),
    );
  }
}
