import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/models/check_in_modal.dart';

class CheckOutProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  CheckIn? _checkIn;
  int? _checkInId;
  final List<String> _ordered = [];

  // Services

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  CheckIn? get checkIn => _checkIn;
  List<String> get ordered => _ordered;
  int? get checkInId => _checkInId;

  // Setters
  void setCheckIn({required CheckIn check}) {
    _checkIn = check;
    notifyListeners();
  }

  void setCheckInId({required int id}) {
    _checkInId = id;
    notifyListeners();
  }

  void clearCheckInId() {
    _checkIn = null;
    notifyListeners();
  }

  void addOrdered({required String orderNo}) {
    _ordered.add(orderNo);
    notifyListeners();
  }

  void clearOrdered() {
    ordered.clear();
    notifyListeners();
  }

  // Initialize

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
