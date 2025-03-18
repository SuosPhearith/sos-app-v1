import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/middlewares/auth_middleware.dart';
import 'package:wsm_mobile_app/providers/global/auth_provider.dart';
import 'package:wsm_mobile_app/providers/global/cart_provider.dart';
import 'package:wsm_mobile_app/providers/global/check_out_provider.dart';
import 'package:wsm_mobile_app/providers/global/selected_customer_provider.dart';
import 'package:wsm_mobile_app/screens/cart_screen.dart';
import 'package:wsm_mobile_app/screens/check_in_detail_screen.dart';
import 'package:wsm_mobile_app/screens/check_in_screen.dart';
import 'package:wsm_mobile_app/screens/customer_screen.dart';
import 'package:wsm_mobile_app/screens/home_screen.dart';
import 'package:wsm_mobile_app/screens/invoice_detail_screen.dart';
import 'package:wsm_mobile_app/screens/login_screen.dart';
import 'package:wsm_mobile_app/screens/new_customer_screen.dart';
import 'package:wsm_mobile_app/screens/profile_screen.dart';
import 'package:wsm_mobile_app/screens/sale_screen.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  await dotenv.load(fileName: '.env.$flavor');

  // Validate required variables
  final requiredVars = ['APP_NAME', 'API_URL', 'API_KEY'];
  for (var variable in requiredVars) {
    if (!dotenv.env.containsKey(variable)) {
      throw Exception('$variable is not set in .env.$flavor');
    }
  }

  // final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  // await flutterSecureStorage.deleteAll();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SelectedCustomerProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CheckOutProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DioClient.setupInterceptors(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        fontFamily: 'Kantumruy',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18), // Custom size if needed
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// ✅ Fixed Router Configuration
final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.home,
  navigatorKey: GlobalKey<NavigatorState>(), // Ensure navigation stability
  routes: [
    // 📌 Routes with Bottom Navigation Layout
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(), // Fix nested navigation issues
      builder: (context, state, child) =>
          AuthMiddleware(child: MainLayout(child: child)),
      routes: [
        GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen()),
        GoRoute(
            path: AppRoutes.sale,
            builder: (context, state) => const SaleScreen()),
        GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen()),
      ],
    ),

    // NO Bottom Navigation
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) =>
          AuthMiddleware(child: const AuthLayout(child: LoginScreen())),
    ),
    GoRoute(
      path: AppRoutes.checkIn,
      builder: (context, state) =>
          AuthMiddleware(child: const AuthLayout(child: CheckInScreen())),
    ),
    GoRoute(
      path: AppRoutes.customer,
      builder: (context, state) =>
          AuthMiddleware(child: const AuthLayout(child: CustomerScreen())),
    ),
    GoRoute(
      path: AppRoutes.newCustomer,
      builder: (context, state) =>
          AuthMiddleware(child: const AuthLayout(child: NewCustomerScreen())),
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) =>
          AuthMiddleware(child: const AuthLayout(child: CartScreen())),
    ),
    GoRoute(
      path: '${AppRoutes.invoiceDetail}/:id', // Dynamic ":id" parameter
      builder: (context, state) {
        final String invoiceId = state.pathParameters['id'] ?? ''; // Get the ID
        return AuthMiddleware(
          child: AuthLayout(
            child: InvoiceDetailScreen(invoiceId: invoiceId), // Pass to screen
          ),
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.checkInDetail}/:id', // Dynamic ":id" parameter
      builder: (context, state) {
        final String invoiceId = state.pathParameters['id'] ?? ''; // Get the ID
        return AuthMiddleware(
          child: AuthLayout(
            child: CheckInDetailScreen(invoiceId: invoiceId), // Pass to screen
          ),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Error: ${state.error}')),
  ),
);

/// ✅ Main Layout with Bottom Navigation Bar
class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({required this.child, super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SaleScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "ទំព័រដើម"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: "វិក្កយបត្រ"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "គណនី"),
        ],
      ),
    );
  }
}

/// ✅ Auth Layout WITHOUT Bottom Navigation Bar
class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child), // Displays the Login or other pages
    );
  }
}
