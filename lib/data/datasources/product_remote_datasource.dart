import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/data/models/product_model.dart';

class ProductRemoteDatasource {
  final http.Client client;
  static const _baseUrl = 'https://fakestoreapi.com/products';

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }

    final responseBody = utf8.decode(response.bodyBytes);
    final data = jsonDecode(responseBody) as List;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add product: ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return ProductModel.fromJson({...product.toJson(), 'id': data['id'] ?? product.id});
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$_baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.statusCode}');
    }

    return product;
  }

  Future<void> deleteProduct(int id) async {
    final response = await client.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }
}
