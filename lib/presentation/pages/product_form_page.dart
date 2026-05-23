import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();

  Product? _editingProduct;
  bool _isLoading = false;

  bool get _isEditing => _editingProduct != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editingProduct == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Product) {
        _editingProduct = args;
        _titleController.text = args.title;
        _priceController.text = args.price.toString();
        _descriptionController.text = args.description;
        _categoryController.text = args.category;
        _imageController.text = args.image;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final viewmodel = context.read<ProductViewmodel>();

    final product = Product(
      id: _isEditing ? _editingProduct!.id : 0,
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      image: _imageController.text.trim().isNotEmpty
          ? _imageController.text.trim()
          : 'https://via.placeholder.com/150',
      ratingRate: _isEditing ? _editingProduct!.ratingRate : 0,
      ratingCount: _isEditing ? _editingProduct!.ratingCount : 0,
    );

    final bool success;
    if (_isEditing) {
      success = await viewmodel.updateProduct(product);
    } else {
      success = await viewmodel.addProduct(product);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Produto atualizado!' : 'Produto cadastrado!',
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewmodel.error ?? 'Erro ao salvar produto.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome do produto',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o preço';
                  if (double.tryParse(v.trim()) == null) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a categoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL da imagem (opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Salvar alterações' : 'Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
