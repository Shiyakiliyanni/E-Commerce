// viewmodels/order_view_model.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  OrderViewModel() {
    fetchOrders();
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    try {
      setLoading(true);
      final user = _auth.currentUser;

      // Check if user is logged in
      if (user == null) {
        print('No user logged in.');
        _orders = [];
        setLoading(false);
        return;
      }

      final ordersRef =
          _firestore.collection('users').doc(user.uid).collection('orders').orderBy('timestamp', descending: true);

      final snapshot = await ordersRef.get();

      log('snapshot ----------------------- ${snapshot.docs}');
      if (snapshot.docs.isEmpty) {
        print('No orders found.');
        _orders = [];
      } else {
        _orders =
            snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
      }
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      setLoading(false);
    }
  }
}
