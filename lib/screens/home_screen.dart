import 'package:fala_ai_unit/models/user_model.dart';
import 'package:fala_ai_unit/screens/login_screen.dart';
import 'package:fala_ai_unit/services/api_service.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final User userData;

  const HomeScreen({super.key, required this.userData});

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
        title: Text('Tela Principal'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(userData: userData.toMap()),
                  ),
                );
              },
              child: Text('Meu perfil'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Função futura para o botão "Agenda"
              },
              child: Text('Agenda'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Função futura para o botão "Marcar reuniões"
              },
              child: Text('Marcar reuniões'),
            ),
          ],
        ),
      ),
    );
  }
}
