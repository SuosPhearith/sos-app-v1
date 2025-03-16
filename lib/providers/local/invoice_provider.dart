import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/models/invoice_modal.dart';
import 'package:wsm_mobile_app/models/pagination_model.dart';
import 'package:wsm_mobile_app/services/invoice_service.dart';

class InvoiceProvider extends ChangeNotifier {
  // Feilds
  bool _isLoading = false;
  String? _error;
  PaginatedResponse<Invoice>? _invoiceRes;

  // Services
  final InvoiceService invoiceService = InvoiceService();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  PaginatedResponse<Invoice>? get invoiceRes => _invoiceRes;

  // Setters

  // Initialize
  InvoiceProvider() {
    getInvoices();
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

  Future<void> getInvoices({
    String keyword = '',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PaginatedResponse<Invoice> data =
          await invoiceService.getInvoices(keyword: keyword);
      _invoiceRes = data;
    } catch (e) {
      _error = "Invalid Credential.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
