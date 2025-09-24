import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/chat/presentation/pages/user_list_page.dart';
import '../providers/auth_provider.dart';
import '../pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return const UserListPage();
    } else {
      return const LoginPage();
    }
  }
}
