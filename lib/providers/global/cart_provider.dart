import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/models/cart_modal.dart';

class CartProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  final List<Cart> _cart = [];

  // Services

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Cart> get cart => _cart;

  // Setters

  // Initialize
  CartProvider() {
    // getHome();
  }

  // Functions
  void addToCart({required Cart cart}) {
    // Check if a product with the same productId already exists in the cart
    int existingIndex =
        _cart.indexWhere((item) => item.productId == cart.productId);

    if (existingIndex != -1) {
      _cart[existingIndex] = Cart(
        productId: _cart[existingIndex].productId,
        qty: _cart[existingIndex].qty + cart.qty,
        note: _cart[existingIndex].note ?? cart.note,
        name: _cart[existingIndex].name,
        unitPrice: _cart[existingIndex].unitPrice,
        thumbnail: _cart[existingIndex].thumbnail ?? cart.thumbnail,
        currency: _cart[existingIndex].currency ?? cart.currency,
      );
    } else {
      // Product doesn't exist, add it as a new item
      _cart.add(cart);
    }

    notifyListeners(); // Notify listeners to update UI
  }

  void removeCart({required Cart cart}) {
    _cart.remove(cart);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void toggleQty({required int productId, required num newQty}) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final existingItem = _cart[index];
      // Remove the old item
      _cart.removeAt(index);
      // Add a new item with updated quantity
      _cart.insert(
        index,
        Cart(
          productId: existingItem.productId,
          qty: newQty,
          note: existingItem.note,
          name: existingItem.name,
          unitPrice: existingItem.unitPrice,
          thumbnail: existingItem.thumbnail,
          currency: existingItem.currency, // Assuming currency exists
        ),
      );
      notifyListeners();
    }
  }

  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Do anything
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
