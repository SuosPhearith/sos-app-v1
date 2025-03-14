import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/providers/global/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Porfile"),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
          onTap: () {
            Provider.of<AuthProvider>(context, listen: false).handleLogout();
          },
          child: Text("logout")),
    );
  }
}
