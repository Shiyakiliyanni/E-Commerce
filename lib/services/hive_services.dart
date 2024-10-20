import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  // Box name for cart data
  static const String cartBoxName = 'cart';

  // Get the cart box
  static Box getCartBox() => Hive.box(cartBoxName);

  // // Add a product to the cart
  // static Future<void> addProduct(Map<String, dynamic> product) async {
  //   final box = getCartBox();
  //   await box.add(product);
  // }

  // // Remove a product from the cart by index
  // static Future<void> removeProduct(int index) async {
  //   final box = getCartBox();
  //   await box.deleteAt(index);
  // }

  // Clear all products from the cart
  // static Future<void> clearCart() async {
  //   final box = getCartBox();
  //   await box.clear();
  // }

  // Retrieve all products from the cart
  // static List<Map<String, dynamic>> getCartItems() {
  //   final box = getCartBox();
  //   return box.values.cast<Map<String, dynamic>>().toList();
  // }
}
