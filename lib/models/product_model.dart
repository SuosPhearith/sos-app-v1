class Product {
  final int id;
  final String thumbnail;
  final String currency;
  final double unitPrice;
  final String name;

  Product({
    required this.id,
    required this.thumbnail,
    required this.currency,
    required this.unitPrice,
    required this.name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      thumbnail: json['thumbnail'] as String,
      currency: json['currency'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(), // Handle int or double
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'currency': currency,
      'unit_price': unitPrice,
      'name': name,
    };
  }
}