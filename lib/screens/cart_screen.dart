import 'package:cart_project/screens/custom_widgets/custom_button.dart';
import 'package:cart_project/screens/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cart_viewmodel.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final deliveryAddress = cartViewModel.deliveryAddress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              cartViewModel.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart cleared!')),
              );
            },
          ),
        ],
      ),
      body: 
      cartViewModel.isLoading == true ? const Center(child: CircularProgressIndicator(),) :
      
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          cartViewModel.cartItems.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              : Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartViewModel.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartViewModel.cartItems[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
                        },
                        child: ListTile(
                          leading: Image.asset(product.imageUrl,fit: BoxFit.fitWidth, height: 60, width: 60,),
                          title: Text(product.name),
                          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              cartViewModel.removeFromCart(product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${product.name} removed from cart')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
          if (deliveryAddress != null && cartViewModel.cartItems.isNotEmpty)
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery Address:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            deliveryAddress,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          ),
                        ),
                      ],
                    )),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payable Amount:',
                          style: TextStyle(fontSize: 16),
                        ),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            '\$ ${cartViewModel.totalAmount.toString()}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
        ],
      ),
      bottomNavigationBar: cartViewModel.cartItems.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                  text:
                      'Checkout - \$${cartViewModel.totalAmount.toStringAsFixed(2)}',
                  onPressed: () async {
                     await cartViewModel.checkout(context, deliveryAddress ?? '');
                  }),
            ),
    );
  }
}
