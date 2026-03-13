import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_1/presentation/viewmodels/product_state.dart';
import 'package:mobile_arquitetura_1/presentation/viewmodels/product_viewmodel.dart';

class ProductPage extends StatelessWidget {
  final ProductViewmodel viewmodel;
  const ProductPage({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: viewmodel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];

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
