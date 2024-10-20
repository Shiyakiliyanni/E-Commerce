
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItem {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  ProductItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory ProductItem.fromMap(Map<String, dynamic> data) {
    return ProductItem(
      id: data['id'] as int,
      name: data['name'] as String,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
      price: (data['price'] as num).toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final List<ProductItem> items;
  final double total;
  final String deliveryAddress;
  final DateTime timestamp;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.deliveryAddress,
    required this.timestamp,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final items = List<Map<String, dynamic>>.from(data['items'])
        .map((item) => ProductItem.fromMap(item))
        .toList();

    return OrderModel(
      id: doc.id,
      items: items,
      total: data['total'] as double,
      deliveryAddress: data['deliveryAddress'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
