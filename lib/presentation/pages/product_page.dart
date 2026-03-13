import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_1/domain/entities/product.dart';
import 'package:mobile_arquitetura_1/presentation/viewmodels/product_viewmodel.dart';

class ProductPage extends StatelessWidget {
  final ProductViewmodel viewmodel;
  const ProductPage({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: viewmodel.products,
        builder: (context, products, _) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: Image.network(product.image),
                title: Text(product.title),
                subtitle: Text("\$${product.price}"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewmodel.loadProducts,
        child: const Icon(Icons.download),
      ),
    );
  }
}
