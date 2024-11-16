import 'package:fala_ai_unit/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fala_ai_unit/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.userData['first_name']);
    _lastNameController =
        TextEditingController(text: widget.userData['last_name']);
    _emailController = TextEditingController(text: widget.userData['email']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    final updatedData = await ApiService.updateUserProfile(
      widget.userData['id'],
      _emailController.text,
      _firstNameController.text,
      _lastNameController.text,
    );

    if (updatedData != null) {
      setState(() {
        widget.userData['first_name'] = updatedData['first_name'];
        widget.userData['last_name'] = updatedData['last_name'];
        widget.userData['email'] = updatedData['email'];
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao atualizar o perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithLogout(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Olá, ${widget.userData['first_name']} ${widget.userData['last_name']}',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _isEditing
                  ? Column(
                      children: [
                        TextField(
                          controller: _firstNameController,
                          decoration:
                              InputDecoration(labelText: 'Primeiro Nome'),
                        ),
                        TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(labelText: 'Último Nome'),
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveChanges,
                          child: Text('Salvar'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Nome: ${widget.userData['first_name']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Sobrenome: ${widget.userData['last_name']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Email: ${widget.userData['email']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _toggleEditMode,
                          child: Text('Editar perfil'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
