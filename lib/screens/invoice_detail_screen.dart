import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wsm_mobile_app/services/invoice_service.dart';
import 'package:wsm_mobile_app/utils/help.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  Map<String, dynamic>? orderDetail; // Make nullable
  List<Map<String, dynamic>>? items; // Make nullable
  bool isLoading = false;
  final InvoiceService invoiceService = InvoiceService();

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    try {
      setState(() {
        isLoading = true;
      });
      final Map<String, dynamic> res =
          await invoiceService.getInvoicesDetail(orderNo: widget.invoiceId);
      final List<Map<String, dynamic>> itemsRes = (res['order_items'] as List)
          .cast<Map<String, dynamic>>(); // Safer cast
      setState(() {
        items = itemsRes;
        orderDetail = res;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading invoice: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleDownload() {
    // Implement download logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("វិក្កយបត្រ"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: handleDownload,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Better loading UI
          : (orderDetail == null || items == null)
              ? const Center(child: Text('No data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: const [
                                Text(
                                  "វិក្កយបត្រ",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(thickness: 2, color: Colors.grey),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "លេខវិក្កយបត្រ: ${orderDetail!['order_no']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "អតិថិជន: ${orderDetail!['customer']['id']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "លេខទូរស័ព្ទ: ${orderDetail!['customer']['phone_number']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "អាសយដ្ឋាន: ${orderDetail!['customer']['address_name']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ចំណាំ: ${orderDetail!['remark']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          const Divider(thickness: 1, color: Colors.grey),
                          const Text(
                            "បញ្ជាទិញទំនិញ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = items![index];
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['product_detail']['name_kh'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${item['qty']} x ${Help.priceValueWithCurrency((item['product_detail']['unit_price'] as num).toDouble(), orderDetail!['currency'] ?? 'USD')}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      Help.priceValueWithCurrency(
                                        ((item['qty'] ?? 1) *
                                            (item['product_detail']
                                                ['unit_price']) as num).toDouble(),
                                        orderDetail!['currency'] ?? 'USD',
                                      ),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Divider(thickness: 1, color: Colors.grey),
                          const Text(
                            "ការចំណាយសង្ខេប",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                              "សរុប:",
                              Help.priceValueWithCurrency(
                                  (orderDetail!['grand_total'] as num)
                                      .toDouble(),
                                  orderDetail!['currency'] ?? "USD")),
                          _buildSummaryRow(
                              "បញ្ចុះតម្លៃ:",
                              Help.priceValueWithCurrency(
                                  0, orderDetail!['currency'] ?? "USD")),
                          _buildSummaryRow(
                            "សរុបចុងក្រោយ:",
                            Help.priceValueWithCurrency(
                                (orderDetail!['grand_total'] as num).toDouble(),
                                orderDetail!['currency'] ?? "USD"),
                            isBold: true,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Created At: ${orderDetail!['created_at'] != null ? Help.formatDateTime(DateTime.parse(orderDetail!['created_at'])) : 'N/A'}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "POS ID: ${orderDetail!['pos_app_id']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
