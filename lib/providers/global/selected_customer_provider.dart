import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/models/customer_model.dart';

class SelectedCustomerProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  Customer? _selectedCustomer;

  // Services

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Customer? get selectedCustomer => _selectedCustomer;

  // Setters
  void setSelectedCustomer(Customer customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void clearSelectedCustomer() {
    _selectedCustomer = null;
    notifyListeners();
  }

  // Initialize
  SelectedCustomerProvider() {
    getHome();
  }

  // Functions
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
