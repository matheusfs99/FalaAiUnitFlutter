import 'package:fala_ai_unit/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  @override
  _ScheduleMeetingScreenState createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  Map<String, dynamic>? _guestUser;
  bool _isLoading = false;
  String? _errorMessage;

  final DateFormat _dateTimeFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  Future<void> _searchUserByEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _guestUser = null;
    });

    final userData = await ApiService.searchUserByEmail(_emailController.text);

    setState(() {
      _isLoading = false;
      if (userData != null) {
        _guestUser = userData;
      } else {
        _errorMessage =
            'Usuário com o email ${_emailController.text} não existe.';
      }
    });
  }

  Future<void> _pickDateTime(BuildContext context, bool isStartTime) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime == null) return;

    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      final formattedDateTime = _dateTimeFormat.format(selectedDateTime);
      if (isStartTime) {
        _startTimeController.text = formattedDateTime;
      } else {
        _endTimeController.text = formattedDateTime;
      }
    });
  }

  Future<void> _scheduleMeeting() async {
    if (_guestUser == null ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final startTime = _dateTimeFormat.parse(_startTimeController.text);
    final endTime = _dateTimeFormat.parse(_endTimeController.text);

    final success = await ApiService.scheduleMeeting(
      _guestUser!['id'],
      _descriptionController.text,
      startTime,
      endTime,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reunião marcada com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao marcar reunião. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithLogout(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email do usuário'),
            ),
            ElevatedButton(
              onPressed: _searchUserByEmail,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Buscar usuário'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_guestUser != null) ...[
              SizedBox(height: 16),
              Text(
                  'Usuário encontrado: ${_guestUser!['first_name']} ${_guestUser!['last_name']}'),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição da Reunião'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _startTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Início da reunião',
                  hintText: 'Selecionar data e hora',
                ),
                onTap: () => _pickDateTime(context, true),
              ),
              TextFormField(
                controller: _endTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fim da reunião',
                  hintText: 'Selecionar data e hora',
                ),
                onTap: () => _pickDateTime(context, false),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _scheduleMeeting,
                child: Text('Marcar Reunião'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
