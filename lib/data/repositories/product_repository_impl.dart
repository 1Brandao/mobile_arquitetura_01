import 'package:mobile_arquitetura_02/core/errors/failure.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();

      cache.save(models);

      return models
          .map((m) => Product(id: m.id, title: m.title, price: m.price))
          .toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached
            .map((m) => Product(id: m.id, title: m.title, price: m.price))
            .toList();
      }
      throw Failure("Nao foi possivel carregar os produtos!");
    }
  }

  // @override
  // void favoriteProduct(int id) {}
}
