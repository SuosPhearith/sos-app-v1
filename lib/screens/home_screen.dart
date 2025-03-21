import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/models/check_in_modal.dart';
import 'package:wsm_mobile_app/providers/global/check_out_provider.dart';
import 'package:wsm_mobile_app/providers/local/home_provider.dart';
import 'package:wsm_mobile_app/services/check_in_service.dart';
import 'package:wsm_mobile_app/utils/help.dart';
import 'package:wsm_mobile_app/utils/type.dart';
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
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer2<CheckOutProvider, HomeProvider>(
          builder: (context, checkOutProvider, homeProvider, child) {
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
            actions: [
              GestureDetector(
                onTap: () {
                  homeProvider.getCheckInHistory();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.sync,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: homeProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : homeProvider.checkInRes == null
                        ? Center(child: const Text('No Data'))
                        : ListView(
                            children: [
                              // Add variable to track previous date
                              () {
                                String? previousDateText;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      homeProvider.checkInRes!.data.map((item) {
                                    // Get current date without time for comparison
                                    final now = DateTime.now();
                                    final today =
                                        DateTime(now.year, now.month, now.day);

                                    // Parse item's checkinAt date
                                    final checkInDateTime =
                                        DateTime.parse(item.checkinAt);
                                    final checkInDate = DateTime(
                                        checkInDateTime.year,
                                        checkInDateTime.month,
                                        checkInDateTime.day);

                                    // Check if the item is from today
                                    final isToday = today == checkInDate;

                                    // Manual date formatting
                                    final dateText = isToday
                                        ? 'ថ្ងៃនេះ'
                                        : '${checkInDateTime.day.toString().padLeft(2, '0')}/'
                                            '${checkInDateTime.month.toString().padLeft(2, '0')}/'
                                            '${checkInDateTime.year}';

                                    // Create date header only if date changes
                                    final dateHeader =
                                        previousDateText != dateText
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, top: 8),
                                                child: Text(
                                                  dateText,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink();

                                    // Update previousDateText for next iteration
                                    previousDateText = dateText;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        dateHeader,
                                        GestureDetector(
                                          onTap: () async {
                                            if (item.checkoutAt.isEmpty) {
                                              await homeProvider.setCheckInId(
                                                  checkInId:
                                                      item.id.toString());
                                              if (context.mounted) {
                                                context.push(AppRoutes.checkIn);
                                              }
                                            } else {
                                              if (context.mounted) {
                                                context.push(
                                                    '${AppRoutes.checkInDetail}/${item.id}');
                                              }
                                            }
                                          },
                                          onLongPress: () {
                                            if (item.checkoutAt.isNotEmpty) {
                                              return showErrorDialog(
                                                  context, 'មិនអាចលុបបានទេ!');
                                            }
                                            showConfirmDialog(
                                              context,
                                              'បញ្ចាក់ការលុប',
                                              "តើអ្នកពិតជាចង់លុប Check In មែនទេ?",
                                              DialogType.danger,
                                              () async {
                                                final checkInService =
                                                    CheckInService();
                                                await checkInService
                                                    .cancelCheckIn(id: item.id);
                                                await homeProvider.setCheckInId(
                                                    checkInId: '');
                                                await homeProvider
                                                    .getCheckInHistory();
                                              },
                                            );
                                          },
                                          child: Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: BorderSide(
                                                color: item.checkoutAt.isEmpty
                                                    ? Colors.blue[200]!
                                                    : Colors.grey[200]!,
                                                width: 1,
                                              ),
                                            ),
                                            color: item.checkoutAt.isEmpty
                                                ? Colors.blue[50]
                                                : Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 4,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: item.checkoutAt
                                                              .isEmpty
                                                          ? Colors.blue[600]
                                                          : Colors.green[600],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.customerId
                                                                  .isEmpty
                                                              ? 'រងចាំការ Check Out'
                                                              : item
                                                                  .customerName,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: item
                                                                    .checkoutAt
                                                                    .isEmpty
                                                                ? Colors
                                                                    .blue[800]
                                                                : Colors
                                                                    .grey[900],
                                                            letterSpacing: 0.2,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 12),
                                                        _buildDateRow(
                                                          'Check-in',
                                                          item.checkinAt,
                                                          Colors.blue[700]!,
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        _buildDateRow(
                                                          'Check-out',
                                                          item.checkoutAt,
                                                          Colors.green[700]!,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                );
                              }(),
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
              bool canCheckIn = await homeProvider.canCheckIn();
              if (!canCheckIn) {
                if (context.mounted) {
                  return showErrorDialog(context, "សូម Check Out សិន");
                }
              }
              setState(() {
                _isLoading = true; // Start loading
              });

              final CheckInService checkInService = CheckInService();
              Map<String, dynamic>? position =
                  await checkInService.getCurrentLatLng();
              setState(() {
                _isLoading = false; // Stop loading
              });

              try {
                if (position != null) {
                  checkOutProvider.setCheckIn(
                      check: CheckIn(
                          checkinAt: Help.getFormattedCurrentDateTime(),
                          lat: position['lat'] ?? 0.0,
                          lng: position['lng'] ?? 0.0,
                          customerId: '',
                          addressName: position['address'] ?? "Unknown"));
                  Map<String, dynamic> res = await checkInService.makeCheckIn(
                      lat: position['lat'].toString(),
                      lng: position['lng'].toString());
                  await homeProvider.setCheckInId(
                      checkInId: res['id'].toString());
                  await homeProvider.getCheckInHistory();
                } else {
                  if (context.mounted) {
                    showErrorDialog(context, "មិនអាចទាញយកទីតាំង");
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorDialog(context, "មិនអាចបង្កើតបានទេ");
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
      }),
    );
  }

  // Helper method for date rows
  Widget _buildDateRow(String label, String date, Color color) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 18,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $date',
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
