import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/models/category_model.dart';
import 'package:wsm_mobile_app/models/product_model.dart';
import 'package:wsm_mobile_app/providers/local/check_in_provider.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final assetUrl = dotenv.env['ASSET_URL'] ?? '';
  int selectedCatId = 0;
  // Debounce for search
  Timer? _debounceTimer;
  final TextEditingController _controller = TextEditingController();
  void _onTextChanged(String value, CheckInProvider checkInProvider) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      checkInProvider.handleGetProducts(keyword: value);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckInProvider(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("Check In"),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Provider.of<CheckInProvider>(context, listen: false).checkOut();
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 14),
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue, width: 1),
                  ),
                  child: const Text('Check Out',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.account_box),
                      SizedBox(width: 10),
                      Text(
                        'ព័ត៌មានអតិថិជន',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.customer),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.account_circle),
                              SizedBox(width: 12),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "ជ្រើសរើសអតិថិជន",
                                  style: TextStyle(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.edit, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.shopping_cart),
                      SizedBox(width: 10),
                      Text(
                        'ដាក់ការបញ្ជារទិញ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Consumer<CheckInProvider>(builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          _onTextChanged(value, provider);
                          setState(() {
                            selectedCatId = 0;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'ស្វែងរកទំនិញ...',
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
                                    _onTextChanged(
                                        '', provider); // Notify provider
                                  },
                                )
                              : null, // No suffix icon when text is empty
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
                  );
                }),
                SizedBox(
                  height: 40,
                  child: Consumer<CheckInProvider>(
                    builder: (context, checkInProvider, child) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCatId = 0;
                              });
                              checkInProvider.handleGetProducts(categoryId: "");
                            },
                            child: Container(
                              width: 90,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedCatId == 0
                                    ? Colors.blue
                                    : Colors.white,
                                border: Border.all(
                                    color: selectedCatId == 0
                                        ? Colors.blue
                                        : Colors.white,
                                    width: 1.0),
                              ),
                              child: Center(
                                child: Text(
                                  "ទាំងអស់",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedCatId == 0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          ...List.generate(checkInProvider.categories.length,
                              (index) {
                            final Category category =
                                checkInProvider.categories[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCatId = category.id;
                                });
                                checkInProvider.handleGetProducts(
                                    categoryId: category.id.toString());
                              },
                              child: Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectedCatId == category.id
                                      ? Colors.blue
                                      : Colors.white,
                                  border: Border.all(
                                      color: selectedCatId == category.id
                                          ? Colors.blue
                                          : Colors.white,
                                      width: 1.0),
                                ),
                                child: Center(
                                  child: Text(
                                    category.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: selectedCatId == category.id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<CheckInProvider>(
                    builder: (context, checkInProvider, child) {
                      if (checkInProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (checkInProvider.productRes == null ||
                          checkInProvider.productRes!.data.isEmpty) {
                        return const Center(child: Text('No products found'));
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: checkInProvider.productRes!.data.length,
                        itemBuilder: (context, index) {
                          final product =
                              checkInProvider.productRes!.data[index];
                          return _buildProductCard(product);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[100] ?? Colors.grey,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(
                    '$assetUrl${product.thumbnail}',
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${product.currency} ${product.unitPrice}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
