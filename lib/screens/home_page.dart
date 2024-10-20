import 'package:cart_project/models/product_model.dart';
import 'package:cart_project/screens/cart_screen.dart';
import 'package:cart_project/screens/login_screen.dart';
import 'package:cart_project/screens/order_screen.dart';
import 'package:cart_project/screens/product_details_page.dart';
import 'package:cart_project/services/authentication_service.dart';
import 'package:cart_project/util/app_colors.dart';
import 'package:cart_project/viewmodel/cart_viewmodel.dart';
import 'package:cart_project/viewmodel/product_viewmodel.dart';
import 'package:cart_project/viewmodel/theme_provider.dart'; // Import Theme Provider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
      _fetchLocation(); // Fetch the location during initialization
    });
  }

  void _loadProducts() {
    final viewModel = Provider.of<ProductViewModel>(context, listen: false);
    final products = viewModel.products;

    for (int i = 0; i < products.length; i++) {
      Future.delayed(Duration(milliseconds: 150 * i), () {
        _listKey.currentState?.insertItem(i);
      });
    }
  }

  void _fetchLocation() {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    cartViewModel
        .requestLocationPermission(); // Fetch and store location in Hive
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: GoogleFonts.lato(),
        ),
      ),
      drawer: _buildDrawer(context, themeProvider, cartViewModel),
      body: Column(
        children: [
          if (cartViewModel.deliveryAddress != null)
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Text(
                'Current Location: ${cartViewModel.deliveryAddress}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Expanded(
            child: viewModel.products.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors().green,
                    ),
                  )
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: 0,
                    itemBuilder: (context, index, animation) {
                      final product = viewModel.products[index];
                      return _buildProductCard(product, animation);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Drawer Widget with Theme Switch and Cart Button
  Widget _buildDrawer(BuildContext context, ThemeProvider themeProvider,
      CartViewModel cartViewModel) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // decoration:
            //     BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'E - Commerce',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? '',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    // color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderScreen()),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              AuthService().signOut().then((_) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
          ),
          SwitchListTile(
            title: const Text('Enable Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            secondary: const Icon(Icons.dark_mode),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: SizedBox(
              height: 50,
              width: 50,
              child: Hero(
                tag: product.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    product.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Text(
              product.name,
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
