class Cart {
  final int productId;        // Required
  final num qty;              // Required, can be int or double
  final String? note;         // Optional, nullable string
  final String name;          // Required, product name
  final num unitPrice;        // Required, price per unit (int or double)
  final String? thumbnail;    // Optional, nullable thumbnail URL or path
  final String? currency;

  Cart({
    required this.productId,
    required this.qty,
    this.note,                // Optional
    required this.name,
    required this.unitPrice,
    this.thumbnail,           // Optional
    this.currency,           // Optional
  });

  // Factory constructor to create a Cart from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productId: json['product_id'] as int,
      qty: json['qty'] as num,          // Handles both int and double
      note: json['note'] as String?,    // Nullable
      name: json['name'] as String,
      unitPrice: json['unit_price'] as num,  // Handles int or double
      thumbnail: json['thumbnail'] as String?, // Nullable
      currency: json['currency'] as String?, // Nullable
    );
  }

  // Method to convert Cart to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'qty': qty,
      'note': note,
      'name': name,
      'unit_price': unitPrice,
      'thumbnail': thumbnail,
      'currency': currency,
    };
  }

  // Optional: toString for debugging
  @override
  String toString() {
    return 'Cart(productId: $productId, qty: $qty, note: $note, name: $name, unitPrice: $unitPrice, thumbnail: $thumbnail)';
  }
}