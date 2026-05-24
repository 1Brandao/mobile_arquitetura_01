class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;
  final double ratingRate;
  final int ratingCount;
  final bool isFavorited;

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final reviews = json["reviews"] as List<dynamic>? ?? [];
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: (json["price"] as num).toDouble(),
      description: json["description"] ?? '',
      image: json["thumbnail"] ?? '',
      category: json["category"] ?? '',
      ratingRate: (json["rating"] as num?)?.toDouble() ?? 0.0,
      ratingCount: reviews.length,
      isFavorited: false,
    );
  }

  factory ProductModel.fromCache(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: (json["price"] as num).toDouble(),
      description: json["description"] ?? '',
      image: json["image"] ?? '',
      category: json["category"] ?? '',
      ratingRate: (json["ratingRate"] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json["ratingCount"] as num?)?.toInt() ?? 0,
      isFavorited: json["isFavorited"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "thumbnail": image,
      "category": category,
      "rating": ratingRate,
    };
  }

  Map<String, dynamic> toCache() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "image": image,
      "category": category,
      "ratingRate": ratingRate,
      "ratingCount": ratingCount,
      "isFavorited": isFavorited,
    };
  }

  ProductModel copyWith({
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
    return ProductModel(
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
