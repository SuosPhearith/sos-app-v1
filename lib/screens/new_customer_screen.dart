import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/models/commune_model.dart';
import 'package:wsm_mobile_app/models/customer_model.dart';
import 'package:wsm_mobile_app/models/district_model.dart';
import 'package:wsm_mobile_app/models/outlet_model.dart';
import 'package:wsm_mobile_app/models/provice_model.dart';
import 'package:wsm_mobile_app/models/village_model.dart';
import 'package:wsm_mobile_app/providers/global/check_out_provider.dart';
import 'package:wsm_mobile_app/providers/global/selected_customer_provider.dart';
import 'package:wsm_mobile_app/providers/local/new_customer_provider.dart';
import 'package:wsm_mobile_app/services/customer_service.dart';
import 'package:wsm_mobile_app/services/new_customer_service.dart';
import 'package:wsm_mobile_app/utils/help.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  Outlet? _selectedOutletType;
  Village? _selectedAddress;

  // TextEditingControllers for all fields
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _secondPhoneController = TextEditingController();
  final TextEditingController _thirdPhoneController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _hotspotController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _customerNameController.dispose();
    _phoneController.dispose();
    _secondPhoneController.dispose();
    _thirdPhoneController.dispose();
    _houseNumberController.dispose();
    _streetNumberController.dispose();
    _streetNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => NewCustomerProvider(),
        child:
            Consumer<NewCustomerProvider>(builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text('បង្កើតអតិថិជន'),
              centerTitle: true,
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: const [
                                  Icon(Icons.account_box),
                                  SizedBox(width: 10),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'ព័ត៌មានអតិថិជនដែលត្រូវការ ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'ឈ្មោះអតិថិជន'),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 8, left: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _customerNameController,
                                  decoration: InputDecoration(
                                    hintText: 'ឈ្មោះអតិថិជន',
                                    prefixIcon: const Icon(Icons.account_circle,
                                        color: Colors.black, size: 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1),
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
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'លេខទូរស័ព្ទអតិថិជន'),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 8, left: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'លេខទូរស័ព្ទអតិថិជន',
                                    prefixIcon: const Icon(Icons.phone,
                                        color: Colors.black, size: 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1),
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
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'ប្រភេទ Outlet'),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                if (provider.isLoading) {
                                  return;
                                }
                                FocusManager.instance.primaryFocus?.unfocus();
                                _outletModal(context, provider.outlets, (code) {
                                  setState(() {
                                    _selectedOutletType = code;
                                  });
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: SizedBox(
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.blue, width: 1),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.store,
                                              color: Colors.black, size: 24),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            child: Text(
                                              _selectedOutletType != null
                                                  ? _selectedOutletType?.name ??
                                                      ""
                                                  : 'ជ្រើសរើសប្រភេទ Outlet',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: Colors.black,
                                              size: 24),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'ជ្រើសរើសទីតាំង'),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                if (provider.isLoading) {
                                  return;
                                }
                                _addressModal(context, provider.provinces,
                                    (code) {
                                  setState(() {
                                    _selectedAddress = code;
                                  });
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Container(
                                  constraints: BoxConstraints(minHeight: 50),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.blue, width: 1),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Icon(Icons.map_outlined,
                                              color: Colors.black, size: 24),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            child: Text(
                                              _selectedAddress != null
                                                  ? _selectedAddress
                                                          ?.fullName ??
                                                      ""
                                                  : 'ជ្រើសរើសទីតាំង',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: Colors.black,
                                              size: 24),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'Hotspot'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _hotspotController,
                                  decoration: InputDecoration(
                                    hintText: 'Hotspot',
                                    prefixIcon: const Icon(Icons.maps_home_work,
                                        color: Colors.black, size: 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1),
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
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: const [
                                  Icon(Icons.account_box),
                                  SizedBox(width: 10),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'ព័ត៌មានបន្ថែម',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'លេខទូរស័ព្ទទី២'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 8, left: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _secondPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'លេខទូរស័ព្ទទី២',
                                    prefixIcon: const Icon(Icons.phone,
                                        color: Colors.black, size: 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1),
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
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'លេខទូរស័ព្ទទី៣'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 8, left: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _thirdPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'លេខទូរស័ព្ទទី៣',
                                    prefixIcon: const Icon(Icons.phone,
                                        color: Colors.black, size: 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1),
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
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'លេខផ្ទះ'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 8, left: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _houseNumberController,
                                  decoration: InputDecoration(
                                    hintText: 'លេខផ្ទះ',
                                    prefixIcon: const Icon(Icons.home,
                                        color: Colors.black, size: 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1),
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
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: 'លេខផ្លូវ'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 8, left: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: _streetNumberController,
                                  decoration: InputDecoration(
                                    hintText: 'លេខផ្លូវ',
                                    prefixIcon: const Icon(Icons.streetview,
                                        color: Colors.black, size: 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1),
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
                          ],
                        ),
                      ),
                    ),
                    // Create Button
                    Consumer<CheckOutProvider>(
                        builder: (context, checkOutProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_customerNameController.text.isEmpty ||
                                  _phoneController.text.isEmpty ||
                                  _selectedAddress == null ||
                                  _selectedOutletType == null) {
                                return showErrorDialog(
                                    context, "ព័ត៌មានមិនគ្រប់គ្រាន់");
                              }
                              // Is valid phone number
                              if (!Help.isValidKhmerPhoneNumber(
                                  _phoneController.text)) {
                                return showErrorDialog(
                                    context, "លេខទូរស័ព្ទមិនត្រឹមត្រូវ");
                              }
                              try {
                                final cusotmerService = CustomerService();
                                final Map<String, dynamic> res =
                                    await cusotmerService.createNewCustomer(
                                        name: _customerNameController.text,
                                        phone: _phoneController.text,
                                        phone2: _secondPhoneController.text,
                                        outletType:
                                            _selectedOutletType?.code ?? "",
                                        phone3: _thirdPhoneController.text,
                                        streetNo: _streetNumberController.text,
                                        houseNo: _houseNumberController.text,
                                        villageCode:
                                            _selectedAddress?.villageCode ?? "",
                                        addressName:
                                            _selectedAddress?.fullName ??
                                                "Unknown",
                                        lat: (checkOutProvider.checkIn?.lat ??
                                                0.0)
                                            .toString(),
                                        lng: (checkOutProvider.checkIn?.lng ??
                                                0.0)
                                            .toString(),
                                        hotspot: _hotspotController.text);
                                if (context.mounted) {
                                  Provider.of<SelectedCustomerProvider>(context,
                                          listen: false)
                                      .setSelectedCustomer(Customer(
                                          id: res['id'] as String,
                                          phoneNumber:
                                              res['phone_number'] as String,
                                          name: res['name'] as String,
                                          wholesaleId:
                                              res['wholesale_id'] as String,
                                          createdAt: DateTime.parse(
                                              res['created_at'] as String),
                                          updatedAt: DateTime.parse(
                                              res['updated_at'] as String)));
                                  showSuccess(context,
                                      message: "បង្កើតដោយជោគជ័យ");
                                  context.go(AppRoutes.checkIn);
                                }
                              } on DioException catch (e) {
                                if (context.mounted) {
                                  // print(e.response?.data?['message']);
                                  showErrorDialog(context,
                                      "${e.response?.data?['message']}");
                                }
                                printError(
                                    errorMessage: ErrorType.somethingWentWrong);
                              } catch (e) {
                                if (context.mounted) {
                                  showErrorDialog(context, e.toString());
                                }
                                printError(
                                    errorMessage: ErrorType.somethingWentWrong);
                              }

                              // print('Customer Name: ${_customerNameController.text}');
                              // print('Phone: ${_phoneController.text}');
                              // print('Outlet Type: $_selectedOutletType');
                              // print('Second Phone: ${_secondPhoneController.text}');
                              // print('Third Phone: ${_thirdPhoneController.text}');
                              // print('House Number: ${_houseNumberController.text}');
                              // print('Street Number: ${_streetNumberController.text}');
                              // print('Street Name: ${_streetNameController.text}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'បង្កើត',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          );
        }));
  }

  void _outletModal(BuildContext context, List<Outlet> outlets,
      void Function(Outlet) onConfirm) {
    Outlet? selectedOutlet;
    List<Outlet> filteredOutlets = List.from(outlets);
    TextEditingController searchController = TextEditingController();
    FocusNode searchFocusNode = FocusNode(); // Added FocusNode for search field

    void unfocus() {
      searchFocusNode.unfocus(); // Helper method to unfocus
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          // Added GestureDetector to catch taps outside
          onTap: unfocus,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ជ្រើសរើសប្រភេទ Outlet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search Field
                      TextField(
                        controller: searchController,
                        focusNode: searchFocusNode, // Assigned FocusNode
                        decoration: InputDecoration(
                          hintText: 'ស្វែងរក Outlet...',
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        onChanged: (value) {
                          setState(() {
                            filteredOutlets = outlets
                                .where((outlet) =>
                                    outlet.name
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    outlet.code
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Outlet List
                      Flexible(
                        child: NotificationListener<ScrollNotification>(
                          // Added NotificationListener for scroll detection
                          onNotification: (scrollNotification) {
                            unfocus();
                            return true;
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: filteredOutlets.isEmpty
                                ? const Center(
                                    child: Text(
                                      'មិនមានលទ្ធផល',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredOutlets.length,
                                    itemBuilder: (context, index) {
                                      final outlet = filteredOutlets[index];
                                      final isSelected =
                                          selectedOutlet == outlet;

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Material(
                                            color: isSelected
                                                ? Colors.blue.shade50
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedOutlet = outlet;
                                                });
                                                unfocus(); // Unfocus when selecting an item
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 12,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            outlet.name,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          // const SizedBox(
                                                          //     height: 2),
                                                          // Text(
                                                          //   outlet.code,
                                                          //   style: TextStyle(
                                                          //     fontSize: 14,
                                                          //     color: Colors.grey
                                                          //         .shade600,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      const Icon(
                                                        Icons.check,
                                                        color: Colors.blue,
                                                        size: 24,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: selectedOutlet != null
                              ? () {
                                  onConfirm(selectedOutlet!);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'ជ្រើសយក',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
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
      },
    );
  }

  void _addressModal(BuildContext context, List<Province> provinces,
      void Function(Village) onConfirm) {
    String label = 'province';
    Province? selectedProvince;
    District? selectedDistrict;
    Commune? selectedCommune;
    Village? selectedVillage;
    List<District> districts = [];
    List<Commune> communes = [];
    List<Village> villages = [];
    List<dynamic> filteredItems =
        List.from(provinces); // Dynamic list for filtering
    TextEditingController searchController = TextEditingController();
    FocusNode searchFocusNode = FocusNode();

    void unfocus() {
      searchFocusNode.unfocus();
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          onTap: unfocus,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Back Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (label !=
                                  'province') // Show back button after province
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      if (label == 'district') {
                                        label = 'province';
                                        filteredItems = provinces;
                                        selectedDistrict = null;
                                        districts = [];
                                        communes = [];
                                        villages = [];
                                      } else if (label == 'commune') {
                                        label = 'district';
                                        filteredItems = districts;
                                        selectedCommune = null;
                                        communes = [];
                                        villages = [];
                                      } else if (label == 'village') {
                                        label = 'commune';
                                        filteredItems = communes;
                                        selectedVillage = null;
                                        villages = [];
                                      }
                                      searchController.clear();
                                    });
                                  },
                                ),
                              Text(
                                label == 'province'
                                    ? 'ជ្រើសរើសខេត្ត'
                                    : label == 'district'
                                        ? 'ជ្រើសរើសស្រុក'
                                        : label == 'commune'
                                            ? 'ជ្រើសរើសឃុំ/សង្កាត់'
                                            : 'ជ្រើសរើសភូមិ',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search Field
                      TextField(
                        controller: searchController,
                        focusNode: searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'ស្វែងរក',
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (label == 'province') {
                              filteredItems = provinces
                                  .where((province) => province.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            } else if (label == 'district') {
                              filteredItems = districts
                                  .where((district) => district.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            } else if (label == 'commune') {
                              filteredItems = communes
                                  .where((commune) => commune.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            } else {
                              filteredItems = villages
                                  .where((village) => village.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Dynamic List
                      Flexible(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            unfocus();
                            return true;
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: filteredItems.isEmpty
                                ? const Center(
                                    child: Text(
                                      'មិនមានលទ្ធផល',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredItems.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];
                                      final isSelected = label == 'province'
                                          ? selectedProvince == item
                                          : label == 'district'
                                              ? selectedDistrict == item
                                              : label == 'commune'
                                                  ? selectedCommune == item
                                                  : selectedVillage == item;

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Material(
                                            color: isSelected
                                                ? Colors.blue.shade50
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  if (label == 'province') {
                                                    selectedProvince =
                                                        item as Province;
                                                    label = 'district';
                                                    filteredItems = districts;
                                                    searchController.clear();
                                                  } else if (label ==
                                                      'district') {
                                                    selectedDistrict =
                                                        item as District;
                                                    label = 'commune';
                                                    filteredItems = communes;
                                                    searchController.clear();
                                                  } else if (label ==
                                                      'commune') {
                                                    selectedCommune =
                                                        item as Commune;
                                                    label = 'village';
                                                    filteredItems = villages;
                                                    searchController.clear();
                                                  } else {
                                                    selectedVillage =
                                                        item as Village;
                                                  }
                                                });
                                                unfocus();

                                                final NewCustomerService
                                                    newCustomerService =
                                                    NewCustomerService();

                                                if (label == 'district' &&
                                                    districts.isEmpty) {
                                                  districts =
                                                      await newCustomerService
                                                          .getDistricts(
                                                    code: selectedProvince
                                                            ?.provinceCode ??
                                                        "",
                                                  );
                                                  setState(() {
                                                    filteredItems = districts;
                                                  });
                                                } else if (label == 'commune' &&
                                                    communes.isEmpty) {
                                                  communes =
                                                      await newCustomerService
                                                          .getCommunes(
                                                    code: selectedDistrict
                                                            ?.districtCode ??
                                                        "",
                                                  );
                                                  setState(() {
                                                    filteredItems = communes;
                                                  });
                                                } else if (label == 'village' &&
                                                    villages.isEmpty) {
                                                  villages =
                                                      await newCustomerService
                                                          .getVillages(
                                                    code: selectedCommune
                                                            ?.communeCode ??
                                                        "",
                                                  );
                                                  setState(() {
                                                    filteredItems = villages;
                                                  });
                                                }
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 12,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        item.name,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      const Icon(
                                                        Icons.check,
                                                        color: Colors.blue,
                                                        size: 24,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: selectedVillage != null
                              ? () {
                                  onConfirm(selectedVillage!);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'ជ្រើសយក',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
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
      },
    );
  }
}
