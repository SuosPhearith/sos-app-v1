import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/models/check_in_history_modal.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  PaginatedResponse<CheckInHistory>? _checkInRes;

  // Services
  final HomeService homeService = HomeService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  PaginatedResponse<CheckInHistory>? get checkInRes => _checkInRes;

  // Setters

  // Initialize
  HomeProvider() {
    getCheckInHistory();
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

  Future<void> getCheckInHistory({
    String keyword = '',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PaginatedResponse<CheckInHistory> data =
          await homeService.getCheckInHistory(keyword: keyword);
      _checkInRes = data;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
