import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_1/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_1/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_1/data/repositories/product_repository_impl.dart';
import 'package:mobile_arquitetura_1/presentation/pages/product_page.dart';
import 'package:mobile_arquitetura_1/presentation/viewmodels/product_viewmodel.dart';

void main() {
  final datasource = ProductRemoteDatasource(http.Client());
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(datasource, cache);
  final viewmodel = ProductViewmodel(repository);

  runApp(MyApp(viewmodel: viewmodel));
}

class MyApp extends StatelessWidget {
  final ProductViewmodel viewmodel;

  const MyApp({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Products',
      home: ProductPage(viewmodel: viewmodel),
    );
  }
}
