import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/check_in_history_modal.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  PaginatedResponse<CheckInHistory>? _checkInRes;
  bool _isPeddingCheckIn = false;

  // Services
  final HomeService homeService = HomeService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  PaginatedResponse<CheckInHistory>? get checkInRes => _checkInRes;
  bool get isPendingCheckIn => _isPeddingCheckIn;

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

  Future<void> setCheckInId({required String checkInId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await secureStorage.write(key: 'checkIn', value: checkInId);
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> canCheckIn() async {
    _isLoading = true;
    notifyListeners();
    try {
      final String? checkInValue = await secureStorage.read(key: 'checkIn');
      return checkInValue == null || checkInValue == '';
    } catch (e) {
      _error = "Invalid Credential.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCheckInId() async {
    _isLoading = true;
    notifyListeners();
    try {
      await secureStorage.delete(key: 'checkIn');
      _isPeddingCheckIn = false;
    } catch (e) {
      _error = ErrorType.unexpectedError;
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
      String isPending = await secureStorage.read(key: 'checkIn') ?? "";
      if (isPending != '') {
        _isPeddingCheckIn = true;
      } else {
        _isPeddingCheckIn = false;
      }
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
