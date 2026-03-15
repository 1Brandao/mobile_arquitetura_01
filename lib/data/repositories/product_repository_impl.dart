import 'package:mobile_arquitetura_02/core/errors/failure.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  Product _toEntity(dynamic m) {
    return Product(
      id: m.id,
      title: m.title,
      price: m.price,
      isFavorited: m.isFavorited,
    );
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final remoteModels = await remote.getProducts();
      final cachedModels = cache.get() ?? [];

      final favoritesById = {for (final c in cachedModels) c.id: c.isFavorited};

      final merged = remoteModels
          .map((m) => m.copyWith(isFavorited: favoritesById[m.id] ?? false))
          .toList();

      cache.save(merged);

      return merged.map(_toEntity).toList();
    } catch (_) {
      final cached = cache.get();
      if (cached != null) {
        return cached.map(_toEntity).toList();
      }
    }
    throw Failure("Nao foi possivel carregar os produtos!");
  }

  @override
  Future<Product> toggleFavorite(int productId) {
    final cached = cache.get();

    if (cached == null || cached.isEmpty) {
      return Future.error(Failure("Nenhum produto em cache para favoritar"));
    }

    final index = cached.indexWhere((p) => p.id == productId);

    if (index == -1) {
      return Future.error(Failure("Produto não encontrado: $productId"));
    }

    final current = cached[index];
    final updated = current.copyWith(isFavorited: !current.isFavorited);

    final updatedList = List.of(cached);
    updatedList[index] = updated;

    cache.save(updatedList);

    return Future.value(_toEntity(updated));
  }
}
