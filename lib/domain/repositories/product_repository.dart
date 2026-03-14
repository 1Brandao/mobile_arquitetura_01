import 'package:mobile_arquitetura_02/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  // void favoriteProduct(int id);
}
