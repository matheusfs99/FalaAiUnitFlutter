import 'package:intl/intl.dart';

class Meeting {
  final int id;
  final Map<String, dynamic> owner;
  final Map<String, dynamic> guest;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  Meeting({
    required this.id,
    required this.owner,
    required this.guest,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  // Converte o JSON recebido para um objeto Meeting
  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      owner: json['owner'],
      guest: json['guest'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }

  // Converte o objeto Meeting para JSON para envio ao backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner,
      'guest': guest,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }

  // Função auxiliar para formatar a data para o formato DD/MM/YYYY HH:mm:ss
  static String _formatDate(DateTime date) {
    final format = DateFormat("dd/MM/yyyy HH:mm:ss");
    return format.format(date);
  }
}
