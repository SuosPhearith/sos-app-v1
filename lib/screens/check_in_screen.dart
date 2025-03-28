import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/models/cart_modal.dart';
import 'package:wsm_mobile_app/models/category_model.dart';
import 'package:wsm_mobile_app/models/check_in_modal.dart';
import 'package:wsm_mobile_app/models/product_model.dart';
import 'package:wsm_mobile_app/providers/global/cart_provider.dart';
import 'package:wsm_mobile_app/providers/global/check_out_provider.dart';
import 'package:wsm_mobile_app/providers/global/selected_customer_provider.dart';
import 'package:wsm_mobile_app/providers/local/check_in_provider.dart';
import 'package:wsm_mobile_app/services/check_in_service.dart';
import 'package:wsm_mobile_app/services/check_out_service.dart';
import 'package:wsm_mobile_app/utils/type.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final assetUrl = dotenv.env['ASSET_URL'] ?? '';
  int selectedCatId = 0;
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
      child:
          Consumer3<SelectedCustomerProvider, CartProvider, CheckOutProvider>(
        builder: (context, selectedCustomerProvider, cartProvider,
            checkOutProvider, child) {
          final isEnabled = selectedCustomerProvider.selectedCustomer != null;
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text("Check In"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (selectedCustomerProvider.selectedCustomer == null) {
                      return context.go(AppRoutes.home);
                    }
                    return showConfirmDialogWithNavigation(
                        context,
                        "បញ្ជាក់ការចេញ",
                        "តើអ្នកពិតជាចង់ចេញមែនទេ?",
                        DialogType.primary, () {
                      selectedCustomerProvider.clearSelectedCustomer();
                      cartProvider.clearCart();
                      context.go(AppRoutes.home);
                    });
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: isEnabled
                          ? () {
                              showConfirmDialog(
                                  context,
                                  "បញ្ជាក់ការ Check Out",
                                  "តើអ្នកពិតជាចង់ Check Out មែនទេ?",
                                  DialogType.primary, () async {
                                try {
                                  final CheckOutService checkOutService =
                                      CheckOutService();
                                  final FlutterSecureStorage secureStorage =
                                      FlutterSecureStorage();
                                  String checkInId = await secureStorage.read(
                                          key: 'checkIn') ??
                                      '';
                                  if (checkInId == '') {
                                    if (context.mounted) {
                                      return showErrorDialog(
                                          context, 'មិនមាន Check_in_id!');
                                    }
                                  }
                                  await checkOutService.checkOut(
                                      checkIn: CheckIn(
                                          checkinAt: '',
                                          lat: 0.0,
                                          lng: 0.0,
                                          customerId: selectedCustomerProvider
                                                  .selectedCustomer?.id ??
                                              "",
                                          addressName: ""),
                                      ordered: checkOutProvider.ordered,
                                      checkInId: int.parse(checkInId));
                                  selectedCustomerProvider
                                      .clearSelectedCustomer();
                                  cartProvider.clearCart();
                                  checkOutProvider.clearOrdered();
                                  await secureStorage.delete(key: 'checkIn');
                                  if (context.mounted) {
                                    context.go(AppRoutes.home);
                                  }
                                  if(context.mounted){
                                    showSuccess(context, message: "ការ Check Out ជោគជ័យ");
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    showError(context, message: "ការCheck Outមានបញ្ហា!");
                                  }
                                }
                              });
                            }
                          : () {
                              showErrorDialog(
                                  context, "សូមជ្រើសរើសអតិថិជនជាមុន!");
                            },
                      icon: Icon(Icons.check_circle,
                          size: 20,
                          color: isEnabled ? Colors.white : Colors.black54),
                      label: Text('Check Out',
                          style: TextStyle(
                              color: isEnabled ? Colors.white : Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                        shadowColor: Colors.black26,
                        elevation: isEnabled ? 4 : 0,
                        backgroundColor:
                            isEnabled ? Colors.blue : Colors.grey[300],
                        foregroundColor: isEnabled ? Colors.blue : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(
                            color: isEnabled ? Colors.blue : Colors.grey[400]!,
                            width: 1.5),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
              body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification ||
                      scrollNotification is ScrollUpdateNotification) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                  return true;
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.account_box),
                                      SizedBox(width: 10),
                                      Text('ព័ត៌មានអតិថិជន',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  isEnabled
                                      ? GestureDetector(
                                          onTap: () {
                                            return showConfirmDialog(
                                                context,
                                                "បញ្ចាក់ការលុប",
                                                'តើអ្នកពិតជាចង់លុបមែនទេ?',
                                                DialogType.danger, () {
                                              selectedCustomerProvider
                                                  .clearSelectedCustomer();
                                            });
                                          },
                                          child: Icon(Icons.delete,
                                              color: Colors.red),
                                        )
                                      : Text('')
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.customer),
                              child: selectedCustomerProvider
                                          .selectedCustomer !=
                                      null
                                  ? CustomerSelected(
                                      name: selectedCustomerProvider
                                              .selectedCustomer?.name ??
                                          "",
                                      phone: selectedCustomerProvider
                                              .selectedCustomer?.phoneNumber ??
                                          "",
                                    )
                                  : Card(
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
                                              children: const [
                                                Icon(Icons.account_circle),
                                                SizedBox(width: 12),
                                                SizedBox(
                                                  width: 250,
                                                  child: Text("ជ្រើសរើសអតិថិជន",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ],
                                            ),
                                            const Icon(Icons.edit,
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.shopping_cart),
                                  SizedBox(width: 10),
                                  Text(
                                      'ដាក់ការបញ្ជារទិញ ${checkOutProvider.ordered.length}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            ...checkOutProvider.ordered.map((order) {
                              return Card(
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
                                      GestureDetector(
                                        onTap: () {
                                          context.push(
                                              '${AppRoutes.invoiceDetail}/$order');
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.receipt),
                                            SizedBox(width: 12),
                                            SizedBox(
                                              width: 250,
                                              child: Text(order,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            showConfirmDialog(
                                                context,
                                                "បញ្ចាក់ការលុប",
                                                "តើអ្នកពិតជាចង់លុបមែនទេ",
                                                DialogType.danger, () async {
                                              try{
                                                final CheckInService
                                                  checkInService =
                                                  CheckInService();
                                              await checkInService.voidOrder(
                                                  id: order);
                                              checkOutProvider.removeOrdered(
                                                  order: order);
                                              if(context.mounted){
                                                showSuccess(context, message: "លុបដោយជោគជ័យ");
                                              }
                                              }catch(e){
                                                if(context.mounted){
                                                  showError(context, message: "លុបមិនជោគជ័យ");
                                                }
                                              }
                                            });
                                          },
                                          child: const Icon(Icons.delete,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 110,
                        maxHeight: 110,
                        child: Container(
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              Consumer<CheckInProvider>(
                                builder: (context, provider, child) {
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
                                          suffixIcon: _controller
                                                  .text.isNotEmpty
                                              ? IconButton(
                                                  icon: const Icon(Icons.close,
                                                      color: Colors.black,
                                                      size: 24),
                                                  onPressed: () {
                                                    _controller.clear();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    _onTextChanged(
                                                        '', provider);
                                                  },
                                                )
                                              : null,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: Colors.blue, width: 1),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 10),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 40,
                                child: Consumer<CheckInProvider>(
                                  builder: (context, checkInProvider, child) {
                                    return ListView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedCatId = 0;
                                            });
                                            checkInProvider.handleGetProducts(
                                                categoryId: "");
                                          },
                                          child: Container(
                                            width: 90,
                                            margin:
                                                const EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                        ...List.generate(
                                            checkInProvider.categories.length,
                                            (index) {
                                          final Category category =
                                              checkInProvider.categories[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedCatId = category.id;
                                              });
                                              checkInProvider.handleGetProducts(
                                                  categoryId:
                                                      category.id.toString());
                                            },
                                            child: Container(
                                              width: 90,
                                              margin: const EdgeInsets.only(
                                                  right: 6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    selectedCatId == category.id
                                                        ? Colors.blue
                                                        : Colors.white,
                                                border: Border.all(
                                                    color: selectedCatId ==
                                                            category.id
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
                                                    color: selectedCatId ==
                                                            category.id
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Consumer<CheckInProvider>(
                        builder: (context, checkInProvider, child) {
                          if (checkInProvider.isLoading) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          }
                          if (checkInProvider.productRes == null ||
                              checkInProvider.productRes!.data.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Center(
                                  child: Text('No products found')),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
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
              floatingActionButton: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  int cartQty = cartProvider.cart.length;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          if (selectedCustomerProvider.selectedCustomer ==
                              null) {
                            return showErrorDialog(
                                context, "សូមជ្រើសរើសអតិថិជន!");
                          }
                          context.push(AppRoutes.cart);
                        },
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.shopping_cart,
                            color: Colors.white),
                      ),
                      if (cartQty > 0)
                        Positioned(
                          right: 0,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            constraints: const BoxConstraints(
                                minWidth: 24, minHeight: 24),
                            child: Text(
                              cartQty.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ),
          );
        },
      ),
    );
  }

  void _showProductModal(BuildContext context, Product product) {
    int quantity = 1;
    TextEditingController qtyController =
        TextEditingController(text: quantity.toString());

    showModalBottomSheet(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Center(
                        child: Image.network(
                          '$assetUrl${product.thumbnail}',
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${product.currency} ${product.unitPrice}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, size: 28),
                        onPressed: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                  qtyController.text = quantity.toString();
                                });
                              }
                            : null,
                      ),
                      SizedBox(
                        width: 100,
                        height: 45,
                        child: TextField(
                          controller: qtyController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                          onChanged: (value) {
                            int? newQty = int.tryParse(value);
                            if (newQty != null && newQty > 0) {
                              setState(() {
                                quantity = newQty;
                              });
                            } else {
                              qtyController.text = "";
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 28),
                        onPressed: () {
                          setState(() {
                            quantity++;
                            qtyController.text = quantity.toString();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(
                                cart: Cart(
                                    productId: product.id,
                                    qty: quantity,
                                    name: product.name,
                                    unitPrice: product.unitPrice,
                                    thumbnail: product.thumbnail,
                                    currency: product.currency));
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text("បញ្ចូលកន្ត្រក",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _showProductModal(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[100] ?? Colors.grey,
                blurRadius: 6,
                spreadRadius: 2)
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
                        color: Colors.grey),
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
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '${product.currency} ${product.unitPrice}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
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

class CustomerSelected extends StatelessWidget {
  final String name;
  final String phone;

  const CustomerSelected({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.blue, width: 1.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      const Icon(Icons.person_outline,
                          size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ឈ្មោះអតិថិជន: $name',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.phone_outlined,
                          size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'លេខទូរស័ព្ទ: $phone',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate(
      {required this.minHeight, required this.maxHeight, required this.child});

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
