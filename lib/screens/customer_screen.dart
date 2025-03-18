import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/providers/global/selected_customer_provider.dart';
import 'package:wsm_mobile_app/providers/local/customer_provider.dart';
import 'package:wsm_mobile_app/services/customer_service.dart';
import 'package:wsm_mobile_app/utils/type.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  Timer? _debounceTimer;
  final TextEditingController _controller = TextEditingController();
  void _onTextChanged(String value, CustomerProvider cusotmerProvider) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      cusotmerProvider.getCustomers(keyword: value);
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
      create: (_) => CustomerProvider(),
      child: Consumer2<CustomerProvider, SelectedCustomerProvider>(
        builder: (context, customerProvider, selectedCustomerProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text("អតិថិជន"),
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
                          _onTextChanged(value, customerProvider);
                        },
                        decoration: InputDecoration(
                          hintText: 'ស្វែងរកអតិថិជន...',
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
                                    _onTextChanged('',
                                        customerProvider); // Notify provider
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
                          'អតិថិជន',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: customerProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : customerProvider.customerRes == null
                              ? const Center(
                                  child: Text('Failed to load customers'))
                              : customerProvider.customerRes!.data.isEmpty
                                  ? const Center(
                                      child: Text('No customers found'))
                                  : ListView(
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                      children: customerProvider
                                          .customerRes!.data
                                          .map((customer) {
                                        return CustomerActionItem(
                                          name: customer.name,
                                          phone: customer.phoneNumber,
                                          onTap: () {
                                            selectedCustomerProvider
                                                .setSelectedCustomer(customer);
                                            context.go(AppRoutes.checkIn);
                                          },
                                          onLongPress: () {
                                            showConfirmDialog(
                                                context,
                                                "បញ្ជាក់ការលុប",
                                                "តើអ្នកពិចជាចង់លុបមែនទេ?",
                                                DialogType.danger, () async {
                                              final CustomerService
                                                  customerService =
                                                  CustomerService();
                                              await customerService
                                                  .removeCustomer(
                                                      id: customer.id);
                                              selectedCustomerProvider.clearSelectedCustomer();
                                              await customerProvider.getCustomers(); // error here
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.newCustomer),
              backgroundColor: Colors.blue,
              label: const Icon(
                Icons.add,
                size: 24,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomerActionItem extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CustomerActionItem({
    super.key,
    required this.name,
    required this.phone,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ឈ្មោះអតិថិជន: $name',
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'លេខទូរស័ព្ទ: $phone',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
