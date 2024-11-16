import 'package:fala_ai_unit/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fala_ai_unit/services/api_service.dart';
import 'package:fala_ai_unit/models/meeting_model.dart';
import 'package:intl/intl.dart';

class MeetingsScreen extends StatefulWidget {
  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  List<Meeting> meetings = [];

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  _loadMeetings() async {
    List<Meeting>? fetchedMeetings = await ApiService.meetings();
    if (fetchedMeetings != null) {
      setState(() {
        meetings = fetchedMeetings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithLogout(),
      body: meetings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                final meeting = meetings[index];

                // Formatação de datas
                String formattedStartTime =
                    DateFormat('dd/MM/yyyy HH:mm:ss').format(meeting.startTime);
                String formattedEndTime =
                    DateFormat('dd/MM/yyyy HH:mm:ss').format(meeting.endTime);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Descrição: ${meeting.description}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text("Início: $formattedStartTime"),
                        Text("Fim: $formattedEndTime"),
                        SizedBox(height: 10),
                        Text("Host: ${meeting.owner['get_full_name']}"),
                        Text("Convidado: ${meeting.guest['get_full_name']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
