import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/providers/global/auth_provider.dart';
import 'package:wsm_mobile_app/utils/type.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = FlutterSecureStorage();
  String? name, appName;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    final String loadedName = await storage.read(key: 'name') ?? '';
    final String loadedAppName = await storage.read(key: 'appName') ?? '';
    if (!mounted) return;
    setState(() {
      name = loadedName;
      appName = loadedAppName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(16),
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    // Replace with your primary color if needed.
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.blue),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image Container
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: ClipOval(
                          child: Icon(
                        Icons.person,
                        size: 48,
                      )),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name ?? 'Guest',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appName ?? 'Unknown Business',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileActionItem(
                      icon: Icons.edit,
                      text: 'Edit Profile',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    ProfileActionItem(
                      icon: Icons.lock_outline,
                      text: 'Change Password',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    ProfileActionItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onTap: () {
                        showConfirmDialog(
                            context,
                            "បញ្ជាក់ការចាកចេញ",
                            "តើអ្នកពិតជាប្រាកដចង់ចាកចេញមែនឬទេ?",
                            DialogType.primary, () async {
                          await authProvider.handleLogout();
                          final FlutterSecureStorage storage =
                              FlutterSecureStorage();
                          await storage.delete(key: 'checkIn');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ProfileActionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const ProfileActionItem({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
