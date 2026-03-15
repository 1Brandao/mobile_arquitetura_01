import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ProductViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Products (${viewmodel.favoriteCount} favoritos)"),
      ),
      body: ListenableBuilder(
        listenable: viewmodel,
        builder: (context, _) {
          if (viewmodel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewmodel.error != null) {
            return Center(child: Text(viewmodel.error!));
          }
          return Column(
            children: [
              SwitchListTile(
                title: const Text("Mostrar apenas favoritos"),
                value: viewmodel.showOnlyFavorites,
                onChanged: viewmodel.setShowOnlyFavorites,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewmodel.products.length,
                  itemBuilder: (context, index) {
                    final product = viewmodel.products[index];

                    return Container(
                      color: product.isFavorited
                          ? Colors.yellow.withValues(alpha: 0.5)
                          : Colors.transparent,
                      child: ListTile(
                        title: Text(product.title),
                        subtitle: Text("\$${product.price}"),
                        trailing: IconButton(
                          icon: Icon(
                            product.isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.isFavorited ? Colors.green : null,
                          ),
                          onPressed: () => viewmodel.toggleFavorite(product.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
