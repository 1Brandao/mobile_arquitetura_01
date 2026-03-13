import 'package:mobile_arquitetura_1/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
