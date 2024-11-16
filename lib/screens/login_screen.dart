import 'package:fala_ai_unit/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Chamamos a função login e esperamos pelo id e token
    Map<String, dynamic>? loginData = await ApiService.login(email, password);

    if (loginData != null && loginData.containsKey('token')) {
      int userId = loginData['id'];

      // Chamamos getUserData usando o token recebido
      Map<String, dynamic>? userData = await ApiService.getUserData(userId);

      if (userData != null) {
        User user = User.fromJson(userData);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userData: user)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to load user data")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
