import 'package:fala_ai_unit/screens/login_screen.dart';
import 'package:fala_ai_unit/services/api_service.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF5199C3),
      title: Center(
        child: Image.asset(
          'assets/images/fala_ai_unit_logo.png',
          height: 200,
        ),
      ),
      toolbarHeight: 200,
      automaticallyImplyLeading: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

class CustomAppBarWithLogout extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showBackButton;

  const CustomAppBarWithLogout({
    Key? key,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(200);

  Future<void> _logout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF5199C3),
      title: Center(
        child: Image.asset(
          'assets/images/fala_ai_unit_logo.png', // Certifique-se de que o caminho esteja correto
          height: 200, // Ajuste conforme necessário
        ),
      ),
      toolbarHeight: 200,
      automaticallyImplyLeading: showBackButton,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _logout(context),
        ),
      ],
    );
  }
}
