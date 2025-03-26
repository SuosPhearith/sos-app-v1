import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wsm_mobile_app/services/invoice_service.dart';
import 'package:wsm_mobile_app/utils/help.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:wsm_mobile_app/widgets/helper.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  Map<String, dynamic>? orderDetail;
  List<Map<String, dynamic>>? items;
  bool isLoading = false;
  final InvoiceService invoiceService = InvoiceService();
  final ScreenshotController invoiceController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    try {
      setState(() => isLoading = true);
      final Map<String, dynamic> res =
          await invoiceService.getInvoicesDetail(orderNo: widget.invoiceId);
      final List<Map<String, dynamic>> itemsRes =
          (res['order_items'] as List).cast<Map<String, dynamic>>();
      setState(() {
        items = itemsRes;
        orderDetail = res;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading invoice: $e');
      setState(() => isLoading = false);
    }
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
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: _saveInvoice,
          ),
          IconButton(
            icon: const Icon(Icons.share), // Add share button
            onPressed: _shareInvoice,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (orderDetail == null || items == null)
              ? const Center(child: Text('No data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Screenshot(
                      controller: invoiceController,
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
                            const SizedBox(height: 15),
                            Text(
                              "ឈ្មោះអតិថិជន: ${orderDetail!['customer']['name']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "លេខទូរស័ព្ទ: ${orderDetail!['customer']['phone_number']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "លេខអតិថិជន: ${orderDetail!['customer']['id']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Hotspot: ${orderDetail!['customer']['hotspot'] ?? ""}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "ថ្ងៃដឹក: ${orderDetail!['shipping']['delivery_date']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "ម៉ោងដឹក: ${orderDetail!['shipping']['time_slot']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "ទីតាំងដឹក: ${orderDetail!['shipping']['shipping_address']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "ចំណាំ: ${orderDetail!['remark'] ?? ""}",
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
                                                      ['unit_price']) as num)
                                              .toDouble(),
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
                                  (orderDetail!['grand_total'] as num)
                                      .toDouble(),
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

  Future<void> _saveInvoice() async {
    final image = await invoiceController.capture();
    if (image == null) return;
    await saveImage(image);
    if (mounted) {
      showSuccess(context, message: "រក្សាទុកដោយជោគជ័យ!");
    }
  }

  Future<void> _shareInvoice() async {
    final image = await invoiceController.capture();
    if (image == null) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/invoice_${widget.invoiceId}.png';
      final file = File(filePath);
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'នេះជាវិក្កយបត្ររបស់អ្នក #${widget.invoiceId}\nអរគុណ! 😊🙏',
      );

      await file.delete();
    } catch (e) {
      debugPrint('Error sharing invoice: $e');
      if (mounted) {
        showError(context, message: "មិនអាច Share បានទេ!");
      }
    }
  }

  Future<bool> saveImage(Uint8List bytes) async {
    try {
      await [Permission.storage].request();
      await FlutterImageGallerySaver.saveImage(bytes);
      return true;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return false;
    }
  }
}
