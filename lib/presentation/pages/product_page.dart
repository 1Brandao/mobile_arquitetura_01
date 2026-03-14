import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';

class ProductPage extends StatelessWidget {
  final ProductViewmodel viewmodel;
  const ProductPage({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ListenableBuilder(
        listenable: viewmodel,
        builder: (context, _) {
          if (viewmodel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewmodel.error != null) {
            return Center(child: Text(viewmodel.error!));
          }
          return ListView.builder(
            itemCount: viewmodel.products.length,
            itemBuilder: (context, index) {
              final product = viewmodel.products[index];

              return ListTile(
                title: Text(product.title),
                subtitle: Text("\$${product.price}"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewmodel.loadProducts,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
