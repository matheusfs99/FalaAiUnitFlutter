import 'package:fala_ai_unit/custom_app_bar.dart';
import 'package:fala_ai_unit/models/user_model.dart';
import 'package:fala_ai_unit/screens/meetings_screen.dart';
import 'package:fala_ai_unit/screens/schedule_meeting_screen.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final User userData;

  const HomeScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithLogout(
        showBackButton: false,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeetingsScreen()),
                );
              },
              child: Text('Agenda'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleMeetingScreen()),
                );
              },
              child: Text('Marcar reuniões'),
            ),
          ],
        ),
      ),
    );
  }
}
