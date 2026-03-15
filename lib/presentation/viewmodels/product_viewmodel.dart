import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  List<Product> get products => _showOnlyFavorites
      ? _products.where((p) => p.isFavorited).toList()
      : _products;
  String? get error => _error;
  int get favoriteCount => _products.where((p) => p.isFavorited).length;

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

  void setShowOnlyFavorites(bool value) {
    _showOnlyFavorites = value;
    notifyListeners();
  }

  Future<void> toogleFavorite(int productId) async {
    _error = null;

    try {
      final updated = await repository.toogleFavorite(productId);
      final index = _products.indexWhere((p) => p.id == updated.id);

      if (index != -1) {
        _products[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
