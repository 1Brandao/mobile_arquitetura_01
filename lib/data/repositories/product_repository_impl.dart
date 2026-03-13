import 'package:mobile_arquitetura_1/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_1/domain/entities/product.dart';
import 'package:mobile_arquitetura_1/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts() async {
    final models = await datasource.getProducts();

    return models
        .map(
          (m) =>
              Product(id: m.id, title: m.title, price: m.price, image: m.image),
        )
        .toList();
  }
}
