import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/services/check_in_service.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

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
        title: Text('ព័ត៌មានលម្អិត'),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.info_rounded),
                              SizedBox(width: 10),
                              Text(
                                'ព័ត៌មានការ Check In',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
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
                          ElevatedButton.icon(
                            onPressed: () async {
                              final double lat = checkInDetail?['lat'];
                              final double lng = checkInDetail?['lng'];
                              final String googleMapsUrl =
                                  'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                              final Uri url = Uri.parse(googleMapsUrl);

                              try {
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode
                                        .externalApplication, // Try opening in Google Maps app
                                  );
                                } else {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode
                                        .platformDefault, // Fallback to browser
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  showErrorDialog(context, "មិនអាចទៅបានទេ");
                                }
                              }
                            },
                            icon: const Icon(Icons.map,
                                color: Colors.white, size: 20), // Icon prefix
                            label: const Text(
                              'ទៅកាន់ផែនទី',
                              style:
                                  TextStyle(color: Colors.white), // White text
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Blue button color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8), // Adjust padding
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8)), // Rounded corners
                            ),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.account_circle_rounded),
                              SizedBox(width: 10),
                              Text(
                                'ព័ត៌មានអតិថិជន',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
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
                          checkInDetail?['customer']?['lat'] != null
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    final double lat =
                                        checkInDetail?['customer']?['lat'];
                                    final double lng =
                                        checkInDetail?['customer']?['lng'];
                                    final String googleMapsUrl =
                                        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                                    final Uri url = Uri.parse(googleMapsUrl);

                                    try {
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(
                                          url,
                                          mode: LaunchMode
                                              .externalApplication, // Try opening in Google Maps app
                                        );
                                      } else {
                                        await launchUrl(
                                          url,
                                          mode: LaunchMode
                                              .platformDefault, // Fallback to browser
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        showErrorDialog(
                                            context, "មិនអាចទៅបានទេ");
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.map,
                                      color: Colors.white,
                                      size: 20), // Icon prefix
                                  label: const Text(
                                    'ទៅកាន់ផែនទី',
                                    style: TextStyle(
                                        color: Colors.white), // White text
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue, // Blue button color
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8), // Adjust padding
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8)), // Rounded corners
                                  ),
                                )
                              : SizedBox()
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_cart),
                              SizedBox(width: 10),
                              Text(
                                'ព័ត៌មានបញ្ជាទិញ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ...(checkInDetail?['visit_plant_actions']
                                as List<dynamic>?)!
                            .map((item) {
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                  '${AppRoutes.invoiceDetail}/${item['action']?['order_no']}');
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.receipt),
                                        SizedBox(width: 12),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            item['action']?['order_no'] ??
                                                'N/A',
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.remove_red_eye,
                                        color: Colors.blue),
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
