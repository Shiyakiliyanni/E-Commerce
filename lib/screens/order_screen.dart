
import 'package:cart_project/viewmodel/order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orderViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderViewModel.orders.isEmpty
              ? const Center(child: Text('No orders found.'))
              : ListView.builder(
                  itemCount: orderViewModel.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderViewModel.orders[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(
                          'Order ID: ${order.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: \$${order.total.toStringAsFixed(2)}'),
                            const SizedBox(height: 5),
                            Text('Address: ${order.deliveryAddress}'),
                            const SizedBox(height: 5),
                            Text(
                              'Ordered on: ${DateFormat('yyyy-MM-dd').format(order.timestamp)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        children: order.items.map((product) {
                          return ListTile(
                            leading: Image.asset(
                              product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.name),
                            subtitle: Text(product.description),
                            trailing: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
    );
  }
}
