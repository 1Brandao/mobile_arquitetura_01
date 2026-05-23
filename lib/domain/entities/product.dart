class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;
  final double ratingRate;
  final int ratingCount;
  final bool isFavorited;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.ratingRate,
    required this.ratingCount,
    this.isFavorited = false,
  });

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? image,
    String? category,
    double? ratingRate,
    int? ratingCount,
    bool? isFavorited,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
      ratingRate: ratingRate ?? this.ratingRate,
      ratingCount: ratingCount ?? this.ratingCount,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
