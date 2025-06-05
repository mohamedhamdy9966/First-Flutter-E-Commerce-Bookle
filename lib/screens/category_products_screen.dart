import 'package:flutter/material.dart';
import '../models/product.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key});

  static const List<Product> products = [
    Product(
      id: '1',
      name: 'Pi',
      category: 'Fiction',
      image: 'assets/images/pi.jpg',
      description: 'Pi',
      price: 29.99,
    ),
    Product(
      id: '2',
      name: 'Kit-Runner',
      category: 'Romance',
      image: 'assets/images/kit-runner.jpg',
      description: 'Kit-Runner',
      price: 59.99,
    ),
    Product(
      id: '3',
      name: 'Help',
      category: 'Politics',
      image: 'assets/images/help.jpg',
      description: 'Help',
      price: 99.99,
    ),
    Product(
      id: '4',
      name: '1984',
      category: 'Politics',
      image: 'assets/images/1984.jpg',
      description: '1984',
      price: 79.99,
    ),
    Product(
      id: '5',
      name: 'Animal Farm',
      category: 'Politics',
      image: 'assets/images/animal-farm.jpg',
      description: 'Animal Farm',
      price: 39.99,
    ),
    Product(
      id: '6',
      name: 'Divergent',
      category: 'Fiction',
      image: 'assets/images/divergent.jpg',
      description: 'Divergent',
      price: 499.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    final filteredProducts = products
        .where((p) => p.category == category)
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, '/product', arguments: product),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('\$${product.price.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
