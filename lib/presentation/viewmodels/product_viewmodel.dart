import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_1/domain/repositories/product_repository.dart';
import 'package:mobile_arquitetura_1/presentation/viewmodels/product_state.dart';

class ProductViewmodel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state = ValueNotifier(const ProductState());

  ProductViewmodel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);

    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(isLoading: true, products: products);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }
}
