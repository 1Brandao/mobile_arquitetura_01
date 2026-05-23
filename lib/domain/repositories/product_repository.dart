import 'package:mobile_arquitetura_02/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> toggleFavorite(int productId);
  Future<Product> addProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(int id);
}
