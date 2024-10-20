import 'package:cart_project/models/product_model.dart';
import 'package:cart_project/repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  ProductViewModel() {
    loadProducts();
  }

  void loadProducts() {
    _products = ProductRepository.getProducts();
    notifyListeners(); // Notify the view when data changes.
  }
}
