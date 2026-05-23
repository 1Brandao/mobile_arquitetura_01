import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/domain/repositories/product_repository.dart';

class ProductViewmodel extends ChangeNotifier {
  final ProductRepository repository;

  bool _showOnlyFavorites = false;
  bool _isLoading = false;
  List<Product> _products = [];
  String? _error;

  bool get showOnlyFavorites => _showOnlyFavorites;
  bool get isLoading => _isLoading;

  UnmodifiableListView<Product> get products {
    final source = _showOnlyFavorites
        ? _products.where((p) => p.isFavorited).toList()
        : _products;
    return UnmodifiableListView(source);
  }

  String? get error => _error;
  int get favoriteCount => _products.where((p) => p.isFavorited).length;

  ProductViewmodel(this.repository);

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await repository.getProducts();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setShowOnlyFavorites(bool value) {
    _showOnlyFavorites = value;
    notifyListeners();
  }

  Future<void> toggleFavorite(int productId) async {
    _error = null;

    try {
      final updated = await repository.toggleFavorite(productId);
      final index = _products.indexWhere((p) => p.id == updated.id);

      if (index != -1) {
        final copy = List<Product>.from(_products);
        copy[index] = updated;
        _products = copy;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addProduct(Product product) async {
    _error = null;
    try {
      final created = await repository.addProduct(product);
      _products = [..._products, created];
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _error = null;
    try {
      final updated = await repository.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        final copy = List<Product>.from(_products);
        copy[index] = updated;
        _products = copy;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    _error = null;
    try {
      await repository.deleteProduct(id);
      _products = _products.where((p) => p.id != id).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
