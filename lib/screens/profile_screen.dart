import 'package:fala_ai_unit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fala_ai_unit/services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User userData;

  const ProfileScreen({super.key, required this.userData});

  Future<void> _logout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, ${userData.firstName} ${userData.lastName}'),
      ),
    );
  }
}
