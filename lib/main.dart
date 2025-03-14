import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/app_routes.dart';
import 'package:wsm_mobile_app/middlewares/auth_middleware.dart';
import 'package:wsm_mobile_app/providers/global/auth_provider.dart';
import 'package:wsm_mobile_app/screens/home_screen.dart';
import 'package:wsm_mobile_app/screens/login_screen.dart';
import 'package:wsm_mobile_app/screens/profile_screen.dart';
import 'package:wsm_mobile_app/screens/sale_screen.dart';
import 'package:wsm_mobile_app/screens/select_app_screen.dart';
import 'package:wsm_mobile_app/screens/todo_screen.dart';
import 'package:wsm_mobile_app/utils/dio.client.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
      routerConfig: _router, // Use GoRouter for navigation
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
            path: AppRoutes.todo,
            builder: (context, state) => const TodoScreen()),
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
      path: AppRoutes.selectApp,
      builder: (context, state) =>
          AuthMiddleware(child: const AuthLayout(child: SelectAppScreen())),
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
    const TodoScreen(),
    const SaleScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _pages[_currentIndex]), // Use IndexedStack to preserve state
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Todo"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Sale"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
