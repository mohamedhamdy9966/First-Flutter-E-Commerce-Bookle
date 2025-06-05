import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../utils/storage.dart';
import 'search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();

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
    Product(
      id: '7',
      name: 'Dream Big',
      category: 'Philosophy',
      image: 'assets/images/dream.jpg',
      description: 'Dream Big',
      price: 4.99,
    ),
    Product(
      id: '8',
      name: '15-minutes',
      category: 'Philosophy',
      image: 'assets/images/15-minutes.jpg',
      description: '15-minutes',
      price: 29.99,
    ),
    Product(
      id: '9',
      name: 'simple self care',
      category: 'Philosophy',
      image: 'assets/images/simple.jpg',
      description: 'simple-self-care',
      price: 29.99,
    ),
    Product(
      id: '10',
      name: 'Me,Myself and us',
      category: 'Romance',
      image: 'assets/images/me.jpg',
      description: 'Me,Myself and us',
      price: 29.99,
    ),
  ];

  static const List<String> categories = ['Fiction', 'Romance', 'Philosophy', 'Politics'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User?>(
          future: Storage.getUser(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            return Text('Welcome, ${snapshot.data?.fullName ?? 'User'}');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(products),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Profile'),
              onTap: () async {
                if (!context.mounted) return;
                await Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: const Text('Cart'),
              onTap: () async {
                if (!context.mounted) return;
                await Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              title: const Text('Orders'),
              onTap: () async {
                if (!context.mounted) return;
                await Navigator.pushNamed(context, '/orders');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await Storage.clearUser();
                if (!context.mounted) return;
                await Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 220,
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: PageView(
                    controller: _controller,
                    children: products
                        .take(3)
                        .map((p) => Image.asset(p.image, fit: BoxFit.cover))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  if (!context.mounted) return;
                  await Navigator.pushNamed(
                    context,
                    '/category',
                    arguments: categories[index],
                  );
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(child: Text(categories[index])),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Featured Products',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 2,
                child: InkWell(
                  onTap: () async {
                    if (!context.mounted) return;
                    await Navigator.pushNamed(
                      context,
                      '/product',
                      arguments: product,
                    );
                  },
                  child: Column(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'New Arrivals',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 2,
                child: InkWell(
                  onTap: () async {
                    if (!context.mounted) return;
                    await Navigator.pushNamed(
                      context,
                      '/product',
                      arguments: product,
                    );
                  },
                  child: Column(
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
        ],
      ),
    );
  }
}
