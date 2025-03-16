import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/error_type.dart';
import 'package:wsm_mobile_app/services/customer_service.dart';
import 'package:wsm_mobile_app/utils/help.dart';
import 'package:wsm_mobile_app/utils/help_util.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  String? _selectedOutletType;

  // TextEditingControllers for all fields
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _secondPhoneController = TextEditingController();
  final TextEditingController _thirdPhoneController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                        padding:
                            const EdgeInsets.only(bottom: 8, right: 8, left: 8),
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
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, left: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _phoneController,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedOutletType = 'retail';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: _selectedOutletType == 'retail'
                                          ? Colors.blue
                                          : Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ហាងលក់រាយ',
                                        style: TextStyle(
                                          color: _selectedOutletType == 'retail'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedOutletType = 'restaurant';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: _selectedOutletType == 'restaurant'
                                          ? Colors.blue
                                          : Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ភោជនីយដ្ឋាន',
                                        style: TextStyle(
                                          color: _selectedOutletType ==
                                                  'restaurant'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedOutletType = 'other';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _selectedOutletType == 'other'
                                          ? Colors.blue
                                          : Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'ផ្សេងៗ',
                                        style: TextStyle(
                                          color: _selectedOutletType == 'other'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, left: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _secondPhoneController,
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
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, left: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _thirdPhoneController,
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
                                  TextSpan(text: 'ផ្ទះលេខ'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, left: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _houseNumberController,
                            decoration: InputDecoration(
                              hintText: 'ផ្ទះលេខ',
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
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, left: 8),
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: 'ឈ្មោះផ្លូវ'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, left: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _streetNameController,
                            decoration: InputDecoration(
                              hintText: 'ឈ្មោះផ្លូវ',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_customerNameController.text.isEmpty ||
                          _phoneController.text.isEmpty ||
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
                        await cusotmerService.createNewCustomer(
                            name: _customerNameController.text,
                            phone: _phoneController.text);
                        if (context.mounted) {
                          context.go(AppRoutes.checkIn);
                        }
                      } catch (e) {
                        printError(errorMessage: ErrorType.somethingWentWrong);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
