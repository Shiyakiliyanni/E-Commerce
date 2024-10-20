import 'package:cart_project/services/notification_service.dart';
import 'package:cart_project/viewmodel/order_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/product_model.dart';

class CartViewModel with ChangeNotifier {
  // Initialize Hive boxes directly
  final Box<Product> _cartBox = Hive.box<Product>('cart');
  final Box<String> _locationBox = Hive.box<String>('location');
  final NotificationService _notificationService = NotificationService();

  List<Product> get cartItems => _cartBox.values.toList();
  String? get deliveryAddress => _locationBox.get('address');
  bool isLoading = false;

  double get totalAmount {
    return cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  void setLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  void addToCart(Product product) {
    _cartBox.put(product.id, product);
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartBox.delete(productId);
    notifyListeners();
  }

  Future<void> clearCart() async {
    await _cartBox.clear();
    notifyListeners();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      fetchAndSaveLocation();
    } else if (status.isDenied) {
      print('Location permission denied.');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<String?> getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String? thoroughfare;
        String? returnPlace;
        print('places ---------------- $place');
        if (place.thoroughfare != null && place.thoroughfare != '') {
          thoroughfare = place.thoroughfare;
        }
        if (thoroughfare != null) {
          returnPlace =
              "${thoroughfare}, ${place.subLocality}, ${place.locality}";
        } else {
          returnPlace = "${place.subLocality}, ${place.locality}";
        }
        return returnPlace;
      }
    } catch (e) {
      print(e); // Handle errors here
    }
    return null;
  }

  Future<void> fetchAndSaveLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      String? address =
          await getPlaceName(position.latitude, position.longitude);
      ;

      _locationBox.put('address', address!);
      notifyListeners();
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  Future<void> checkout(BuildContext context, String deliveryAddress) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      setLoading(true);
      final items = cartItems.map((product) => product.toMap()).toList();
      // Store the order in Firebase Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('orders')
          .add({
        'items': items,
        'total': totalAmount,
        'deliveryAddress': deliveryAddress,
        'timestamp': Timestamp.now(),
      });

      // Clear the cart after checkout
      await clearCart();

      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      OrderViewModel().fetchOrders();

      // Show a local notification
      await _notificationService.showNotification(
        'Order Confirmed',
        'Your order has been placed successfully!',
      );
    } catch (e) {
      print('Checkout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place the order.')),
      );
      setLoading(false);
    }
  }
}
