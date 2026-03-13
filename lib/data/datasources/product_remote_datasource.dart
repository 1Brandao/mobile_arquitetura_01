import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_1/data/models/product_model.dart';

class ProductRemoteDatasource {
  final http.Client client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse('https://fakestoreapi.com/products'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }

    final responseBody = utf8.decode(response.bodyBytes);
    final data = jsonDecode(responseBody) as List;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
