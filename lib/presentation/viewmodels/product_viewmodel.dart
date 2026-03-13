import 'package:flutter/cupertino.dart';
import 'package:mobile_arquitetura_1/domain/entities/product.dart';
import 'package:mobile_arquitetura_1/domain/repositories/product_repository.dart';

class ProductViewmodel {
  final ProductRepository repository;

  final ValueNotifier<List<Product>> products = ValueNotifier([]);

  ProductViewmodel(this.repository);

  Future<void> loadProducts() async {
    final result = await repository.getProducts();
    products.value = result;
  }
}
