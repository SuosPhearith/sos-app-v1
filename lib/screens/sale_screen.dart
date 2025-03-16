import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/providers/local/invoice_provider.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  Timer? _debounceTimer;
  final TextEditingController _controller = TextEditingController();
  void _onTextChanged(String value, InvoiceProvider provider) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      provider.getInvoices(keyword: value);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceProvider(),
      child: Consumer<InvoiceProvider>(
        builder: (context, invoiceProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text(
                "វិក្កយបត្រ",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          _onTextChanged(value, invoiceProvider);
                        },
                        decoration: InputDecoration(
                          hintText: 'ស្វែងរកវិក្កយបត្រ...',
                          prefixIcon: const Icon(Icons.search,
                              color: Colors.black, size: 28),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.black, size: 24),
                                  onPressed: () {
                                    _controller.clear(); // Clear the text
                                    FocusScope.of(context)
                                        .unfocus(); // Remove focus
                                    _onTextChanged(
                                        '', invoiceProvider); // Notify provider
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(Icons.account_box),
                        SizedBox(width: 10),
                        Text(
                          'វិក្កយបត្រ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: invoiceProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : invoiceProvider.invoiceRes == null
                              ? const Center(
                                  child: Text('Failed to load invoices'))
                              : invoiceProvider.invoiceRes!.data.isEmpty
                                  ? const Center(
                                      child: Text('No invoices found'))
                                  : ListView(
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                      children: invoiceProvider.invoiceRes!.data
                                          .map((invoice) {
                                        return InvoiceActionItem(
                                          currency: invoice.currency,
                                          customerName: invoice.customer.name,
                                          customerPhone:
                                              invoice.customer.phoneNumber,
                                          deliveryDate: invoice.deliveryDate,
                                          grandTotal: invoice.grandTotal,
                                          orderNo: invoice.orderNo,
                                          onTap: () {},
                                        );
                                      }).toList(),
                                    ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InvoiceActionItem extends StatelessWidget {
  final String orderNo;
  final double grandTotal;
  final String currency;
  final String customerName;
  final String customerPhone;
  final String deliveryDate;
  final VoidCallback? onTap;

  const InvoiceActionItem({
    super.key,
    required this.orderNo,
    required this.grandTotal,
    required this.currency,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Number
            Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  size: 20,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'លេខកម្ម៉ង់: $orderNo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Customer Info
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 20,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ឈ្មោះអតិថិជន: $customerName',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 20,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'លេខទូរស័ព្ទ: $customerPhone',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Grand Total
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 20,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'សរុប: $grandTotal $currency',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Delivery Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  'ថ្ងៃដឹក: $deliveryDate',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
