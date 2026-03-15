class ProductModel {
  final int id;
  final String title;
  final double price;
  final bool isFavorited;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    this.isFavorited = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      isFavorited: false,
    );
  }
  factory ProductModel.fromCache(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      isFavorited: json["isFavorited"] ?? false,
    );
  }

  Map<String, dynamic> toCache() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "isFavorited": isFavorited,
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    bool? isFavorited,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
