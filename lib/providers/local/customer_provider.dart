import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/models/customer_model.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/services/customer_service.dart';

class CustomerProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  PaginatedResponse<Customer>? _customerRes;

  // Services
  final CustomerService customerService = CustomerService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  PaginatedResponse<Customer>? get customerRes => _customerRes;

  // Setters

  // Initialize
  CustomerProvider() {
    getCustomers();
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

  Future<void> getCustomers({
    String keyword = '',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PaginatedResponse<Customer> data =
          await customerService.getCustomers(keyword: keyword);
      _customerRes = data;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
