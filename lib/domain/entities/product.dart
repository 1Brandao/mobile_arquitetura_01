class Product {
  final int id;
  final String title;
  final double price;
  bool isFavorited;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.isFavorited = false,
  });
}
