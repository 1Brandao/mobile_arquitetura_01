import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/domain/repositories/product_repository.dart';

class ProductViewmodel extends ChangeNotifier {
  final ProductRepository repository;

  bool _isLoading = false;
  List<Product> _products = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<Product> get products => _products;
  String? get error => _error;

  ProductViewmodel(this.repository);

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final products = await repository.getProducts();
      _products = products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
