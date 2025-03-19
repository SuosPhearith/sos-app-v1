import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/models/outlet_model.dart';
import 'package:wsm_mobile_app/models/provice_model.dart';
import 'package:wsm_mobile_app/services/new_customer_service.dart';

class NewCustomerProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  List<Outlet> _outlets = [];
  List<Province> _provinces = [];

  // Services
  final NewCustomerService newCustomerService = NewCustomerService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Outlet> get outlets => _outlets;
  List<Province> get provinces => _provinces;

  // Setters

  // Initialize
  NewCustomerProvider() {
    getHome();
  }

  // Functions
  Future<void> getHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Outlet> res = await newCustomerService.getOutlets();
      List<Province> resProvinces = await newCustomerService.getProvices();
      _outlets = res;
      _provinces = resProvinces;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
