import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/models/check_in_modal.dart';
import 'package:wsm_mobile_app/providers/global/check_out_provider.dart';
import 'package:wsm_mobile_app/services/check_in_service.dart';
import 'package:wsm_mobile_app/utils/help.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false; // State variable to track loading

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckOutProvider>(
        builder: (context, checkOutProvider, child) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text(
            'Check In',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 4,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  ...[1].map((item) {
                    return GestureDetector(
                      onTap: () {
                        // context.push(AppRoutes.checkIn);
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mountain View',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.map,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Lat: 14.003  |  Lng: 106.003',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    _buildDateRow(
                                      'Check-in',
                                      '12/16/2025',
                                      Colors.blue[700]!,
                                    ),
                                    const SizedBox(height: 6),
                                    _buildDateRow(
                                      'Check-out',
                                      '12/17/2025',
                                      Colors.red[700]!,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Show loading indicator when _isLoading is true
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            setState(() {
              _isLoading = true; // Start loading
            });

            final CheckInService checkInService = CheckInService();
            Position? position = await checkInService.getCurrentLocation();

            setState(() {
              _isLoading = false; // Stop loading
            });

            if (position != null) {
              checkOutProvider.setCheckIn(
                  check: CheckIn(
                      checkinAt: Help.getFormattedCurrentDateTime(),
                      lat: position.latitude,
                      lng: position.longitude,
                      customerId: ''));
              if (context.mounted) {
                context.push(AppRoutes.checkIn);
              }
            } else {
              if (context.mounted) {
                showErrorDialog(context, "មិនអាចទាញយកទីតាំង");
              }
            }
          },
          backgroundColor: Colors.blue,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          label: Row(
            children: const [
              Icon(
                Icons.add,
                size: 24,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'បង្កើត Check In',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Helper method for date rows
  Widget _buildDateRow(String label, String date, Color color) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $date',
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
