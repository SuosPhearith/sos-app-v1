import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/services/check_in_service.dart'; // Your service

class CheckInDetailScreen extends StatefulWidget {
  final String invoiceId;
  const CheckInDetailScreen({super.key, required this.invoiceId});

  @override
  State<CheckInDetailScreen> createState() => _CheckInDetailScreenState();
}

class _CheckInDetailScreenState extends State<CheckInDetailScreen> {
  Map<String, dynamic>? checkInDetail;
  bool isLoading = false;
  final CheckInService checkInService = CheckInService();

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    try {
      setState(() => isLoading = true);
      final Map<String, dynamic> res =
          await checkInService.getCheckInDetail(id: widget.invoiceId);
      setState(() {
        checkInDetail = res;
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Detail'),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : checkInDetail == null
              ? const Center(child: Text('No data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('ព័ត៌មានការ Check In'),
                        _buildInfoCard([
                          _buildInfoRow('Check-In',
                              checkInDetail?['checkin_at'] ?? 'N/A'),
                          _buildInfoRow('Check-Out',
                              checkInDetail?['checkout_at'] ?? 'N/A'),
                          _buildInfoRow(
                              'Status', checkInDetail?['status'] ?? 'N/A'),
                          _buildInfoRow('Latitude',
                              checkInDetail?['lat']?.toString() ?? 'N/A'),
                          _buildInfoRow('Longitude',
                              checkInDetail?['lng']?.toString() ?? 'N/A'),
                        ]),
                        const SizedBox(height: 16),
                        _buildSectionTitle('ព័ត៌មានអតិថិជន'),
                        _buildInfoCard([
                          _buildInfoRow('Name',
                              checkInDetail?['customer']?['name'] ?? 'N/A'),
                          _buildInfoRow(
                              'Phone',
                              checkInDetail?['customer']?['phone_number'] ??
                                  'N/A'),
                          _buildInfoRow(
                              'Address',
                              checkInDetail?['customer']?['address_name'] ??
                                  'Not provided'),
                        ]),
                        const SizedBox(height: 16),
                        _buildSectionTitle('ព័ត៌មានបញ្ជាទិញ'),
                        ...(checkInDetail?['visit_plant_actions']
                                as List<dynamic>?)!
                            .map((item) {
                          return GestureDetector(
                            onTap: (){
                              context.push('${AppRoutes.invoiceDetail}/${item['action']?['order_no']}');
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.blue[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Order No: "),
                                    Text(
                                        '${item['action']?['order_no'] ?? 'N/A'}')
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
