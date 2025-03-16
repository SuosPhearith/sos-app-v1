import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/models/cart_modal.dart';
import 'package:wsm_mobile_app/providers/global/cart_provider.dart';
import 'package:wsm_mobile_app/providers/global/selected_customer_provider.dart';
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
    return Scaffold(
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
              _buildBottomSection(context, cartProvider, selectedCustomerProvider),
            ],
          );
        },
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
  Widget _buildBottomSection(BuildContext context, CartProvider cartProvider, SelectedCustomerProvider selectedCustomerProvider) {
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
          Row(
            children: [
              // Delivery Date Field
              Expanded(
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelText: 'ថ្ងៃដឹក', // Shortened: "Delivery date"
                    errorText: _loactoinError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // Smaller radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            _loactoinError != null ? Colors.red : Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Delivery Time Field
              Expanded(
                child: TextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null && context.mounted) {
                      String formattedTime = pickedTime.format(context);
                      setState(() {
                        _timeController.text = formattedTime;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.access_time),
                    labelText: 'ម៉ោងដឹក', // Shortened: "Delivery time"
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Reduced from 10
          // Remark Field
          TextField(
            controller: _remarkController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.note),
              labelText: 'ចំណាំ', // Shortened: "Remark"
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
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
                    return showConfirmDialog(context, "បញ្ជាក់ការកម្ម៉ង់","តើអ្នកពិតជាចង់ដាក់ការកម្ម៉ង់មែនទេ?", DialogType.primary, (){
                      cartProvider.clearCart();
                      selectedCustomerProvider.clearSelectedCustomer();
                      context.go(AppRoutes.home);
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
}
