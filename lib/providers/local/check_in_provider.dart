import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/category_model.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/models/product_model.dart';
import 'package:wsm_mobile_app/services/check_in_service.dart';

class CheckInProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  List<Category> _categories = [];
  PaginatedResponse<Product>? _productRes;

  // Services
  final CheckInService checkInService = CheckInService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Category> get categories => _categories;
  PaginatedResponse<Product>? get productRes => _productRes;

  // Setters

  // Initialize
  CheckInProvider() {
    handleGetcategories();
    handleGetProducts();
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

  Future<void> handleGetcategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Category> data = await checkInService.getCategories();
      _categories = data;
    } catch (e) {
      _error = ErrorType.somethingWentWrong;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleGetProducts({
    String categoryId = '',
    String keyword = '',
    int page = 1,
    int perPage = 20,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PaginatedResponse<Product> data = await checkInService.getProducts(
          categoryId: categoryId, keyword: keyword);
      _productRes = data;
    } catch (e) {
      _error = ErrorType.somethingWentWrong;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
