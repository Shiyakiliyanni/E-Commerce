import 'package:cart_project/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    // Check if the product is in the cart based on its ID
    bool isInCart = cartViewModel.cartItems
        .any((item) => item.id == product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: GoogleFonts.lato()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: product.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.lato(
                        fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.favorite_outline, color: Colors.red),
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        icon: Icon(
                          isInCart
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                        ),
                        onPressed: () {
                          if (isInCart) {
                            cartViewModel.removeFromCart(product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Product Removed from Cart')),
                            );
                          } else {
                            cartViewModel.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Product Added to Cart')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
              const SizedBox(height: 16.0),
              Text(
                product.description,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
