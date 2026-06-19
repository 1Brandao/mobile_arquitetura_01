import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/core/app_routes.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    ProductViewmodel viewmodel,
    int productId,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await viewmodel.deleteProduct(productId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Produto excluído!'
                  : viewmodel.error ?? 'Erro ao excluir',
            ),
            backgroundColor: success ? null : Colors.red,
          ),
        );
      }
    }
  }

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
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.image,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                const Icon(Icons.broken_image, size: 40),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const SizedBox(
                                width: 56,
                                height: 56,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        title: Text(product.title),
                        subtitle: Text("\$${product.price}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                product.isFavorited
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: product.isFavorited
                                    ? Colors.green
                                    : null,
                              ),
                              onPressed: () =>
                                  viewmodel.toggleFavorite(product.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final updated = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.formPage,
                                  arguments: product,
                                );
                                if (updated == true && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Produto atualizado!'),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(
                                context,
                                viewmodel,
                                product.id,
                                product.title,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.detailsPage,
                          arguments: product,
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.formPage),
            tooltip: 'Novo produto',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: viewmodel.loadProducts,
            tooltip: 'Atualizar',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
