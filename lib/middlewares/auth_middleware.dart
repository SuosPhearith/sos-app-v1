import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/providers/global/auth_provider.dart';
import 'package:wsm_mobile_app/screens/login_screen.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;
  const AuthMiddleware({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      if (auth.isLoggedIn) {
        return child;
      }
      return LoginScreen();
    });
  }
}
