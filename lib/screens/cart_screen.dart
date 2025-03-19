import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/models/cart_modal.dart';
import 'package:wsm_mobile_app/providers/global/cart_provider.dart';
import 'package:wsm_mobile_app/providers/global/check_out_provider.dart';
import 'package:wsm_mobile_app/providers/global/selected_customer_provider.dart';
import 'package:wsm_mobile_app/services/cart_service.dart';
import 'package:wsm_mobile_app/utils/help.dart';
import 'package:wsm_mobile_app/utils/type.dart';
import 'package:wsm_mobile_app/widgets/helper.dart'; // Your Cart model

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String? _loactoinError; // Track location validation error

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Cart'),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                showConfirmDialog(context, "បញ្ចាក់ការលុប",
                    "តើអ្នកពិតជាចង់លុបមែនទេ?", DialogType.danger, () {
                  return Provider.of<CartProvider>(context, listen: false)
                      .clearCart();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
        body: Consumer2<CartProvider, SelectedCustomerProvider>(
          builder: (context, cartProvider, selectedCustomerProvider, child) {
            if (cartProvider.cart.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return Column(
              children: [
                // Cart Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: cartProvider.cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProvider.cart[index];
                      return _buildCartItem(context, cartItem, cartProvider);
                    },
                  ),
                ),
                // Bottom Section: Total Amount and Submit Button
                _buildBottomSection(
                    context, cartProvider, selectedCustomerProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  // Cart Item Widget
  Widget _buildCartItem(
      BuildContext context, Cart cartItem, CartProvider cartProvider) {
    final assetUrl = dotenv.env['ASSET_URL'] ?? '';
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: cartItem.thumbnail != null
                  ? Image.network(
                      '$assetUrl${cartItem.thumbnail}',
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 12),
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'តម្លៃ: ${cartItem.currency} ${cartItem.unitPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        'ចំនួន: ',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: cartItem.qty > 1
                            ? () {
                                cartProvider.toggleQty(
                                  productId: cartItem.productId,
                                  newQty: cartItem.qty - 1,
                                );
                              }
                            : null,
                      ),
                      Text(
                        '${cartItem.qty}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {
                          cartProvider.toggleQty(
                            productId: cartItem.productId,
                            newQty: cartItem.qty + 1,
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'សរុប: ${cartItem.currency} ${(cartItem.unitPrice * cartItem.qty).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            // Remove Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cartProvider.removeCart(cart: cartItem);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Section: Total Amount and Submit Button
  Widget _buildBottomSection(BuildContext context, CartProvider cartProvider,
      SelectedCustomerProvider selectedCustomerProvider) {
    final totalAmount = cartProvider.cart.fold<double>(
      0.0,
      (sum, item) => sum + (item.unitPrice * item.qty).toDouble(),
    );

    return Container(
      padding: const EdgeInsets.all(12.0), // Reduced from 16.0
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.account_box),
                    SizedBox(width: 10),
                    Text(
                      'ព័ត៌មានការកម្ម៉ង់',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      _dateController.clear();
                      _timeController.clear();
                      _remarkController.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(
                      "លុបព័ត៌មាន",
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          // Date and Time in One Row
          Card(
            elevation: 0,
            color: Colors.white,
            child: TextField(
              controller: _dateController,
              readOnly: true, // Prevents manual input
              onTap: () async {
                // Show date picker when tapped
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // Default selected date is today
                  firstDate:
                      DateTime.now(), // Earliest selectable date is today
                  lastDate: DateTime(2101), // Latest selectable date is 2101
                );
                if (pickedDate != null) {
                  // Format the date and set it to the controller
                  String formattedDate =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  setState(() {
                    _dateController.text = formattedDate;
                  });
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                    Icons.calendar_today), // Changed to calendar icon
                labelText: 'បញ្ចូលថ្ងៃដឹក', // "Enter delivery date"
                errorText: _loactoinError, // Show error message
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _loactoinError != null ? Colors.red : Colors.blue,
                    width: 1.0, // Red border if error, blue otherwise
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2.0, // Border color when focused
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              showTimeModal(context, (e) {
                setState(() {
                  _timeController.text = e;
                });
              });
            },
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.blue,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.av_timer_sharp), // Prefix icon
                          const SizedBox(
                              width: 12), // Space between icon and text
                          SizedBox(
                            width: 250,
                            child: Text(
                              _timeController.text.isNotEmpty
                                  ? _timeController.text
                                  : "ជ្រើសរើសម៉ោងដឹក",
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1, // Limits to 1 line
                              overflow: TextOverflow
                                  .ellipsis, // Adds "..." when truncated
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            child: TextField(
              controller: _remarkController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.border_color),
                labelText: 'បញ្ចូលចំណាំ',
                errorText: _loactoinError, // Show error message
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _loactoinError != null ? Colors.red : Colors.blue,
                      width: 1.0), // Red border if error, blue otherwise
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0), // Border color when focused
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15), // Reduced from 10
          // Total Amount and Submit Button
          ElevatedButton(
            onPressed: cartProvider.cart.isEmpty ||
                    _dateController.text.isEmpty ||
                    _timeController.text.isEmpty
                ? () {
                    return showErrorDialog(context, "សូមបញ្ចូលព័ត៌មាន!");
                  }
                : () {
                    return showConfirmDialog(
                        context,
                        "បញ្ជាក់ការកម្ម៉ង់",
                        "តើអ្នកពិតជាចង់ដាក់ការកម្ម៉ង់មែនទេ?",
                        DialogType.primary, () async {
                      final CartService cartService = CartService();
                      Map<String, dynamic> res = await cartService.makeOrder(
                          cart: cartProvider.cart,
                          customerId:
                              selectedCustomerProvider.selectedCustomer?.id ??
                                  '',
                          deliveryDate:
                              Help.convertDateFormat(_dateController.text),
                          timeSlot: _timeController.text,
                          remark: _remarkController.text);
                      if (context.mounted) {
                        Provider.of<CheckOutProvider>(context, listen: false)
                            .addOrdered(orderNo: res['order_no']);
                      }
                      cartProvider.clearCart();
                      if (context.mounted) {
                        context.go(AppRoutes.checkIn);
                      }
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'សរុប: ${cartProvider.cart[0].currency} ${totalAmount.toStringAsFixed(2)} កម្ម៉ង់',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  void showTimeModal(BuildContext context, void Function(String) onConfirm) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'សូមជ្រើសរើសម៉ោងដឹក',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              onConfirm('09AM - 12PM');
                              Navigator.pop(
                                  context); // Close modal after selection
                            },
                            child: Container(
                              width: 120, // Fixed width for consistency
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.blue.shade300, width: 1.2),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'ពេលព្រឹក',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '09AM - 12PM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blueGrey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8), // Gap between items
                          GestureDetector(
                            onTap: () {
                              onConfirm('01PM - 04PM');
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.blue.shade300, width: 1.2),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'ពេលថ្ងៃ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '01PM - 04PM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blueGrey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              onConfirm('05AM - 08PM');
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.blue.shade300, width: 1.2),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'ពេលរសៀល',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '05AM - 08PM',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blueGrey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
