import 'package:mobile_arquitetura_02/core/errors/failure.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/models/product_model.dart';
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
      description: m.description,
      image: m.image,
      category: m.category,
      ratingRate: m.ratingRate,
      ratingCount: m.ratingCount,
      isFavorited: m.isFavorited,
    );
  }

  ProductModel _toModel(Product p) {
    return ProductModel(
      id: p.id,
      title: p.title,
      price: p.price,
      description: p.description,
      image: p.image,
      category: p.category,
      ratingRate: p.ratingRate,
      ratingCount: p.ratingCount,
      isFavorited: p.isFavorited,
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

  @override
  Future<Product> addProduct(Product product) async {
    final model = _toModel(product);
    final created = await remote.addProduct(model);

    final cached = List<ProductModel>.from(cache.get() ?? []);
    cached.add(created);
    cache.save(cached);

    return _toEntity(created);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final model = _toModel(product);
    final updated = await remote.updateProduct(model);

    final cached = cache.get() ?? [];
    final index = cached.indexWhere((p) => p.id == updated.id);

    if (index != -1) {
      final updatedList = List<ProductModel>.from(cached);
      updatedList[index] = updated;
      cache.save(updatedList);
    }

    return _toEntity(updated);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await remote.deleteProduct(id);

    final cached = cache.get() ?? [];
    final updatedList = cached.where((p) => p.id != id).toList();
    cache.save(updatedList);
  }
}
