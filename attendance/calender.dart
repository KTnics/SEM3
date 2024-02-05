import 'package:final_sem_project/attendance/events.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};
  TextEditingController _eventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              _fetchEvents(selectedDay);
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _eventController,
              decoration: InputDecoration(
                hintText: 'Enter event',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addEvent();
            },
            child: Text('Mark Date'),
          ),
          SizedBox(height: 20),
        ElevatedButton(onPressed: (){

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventsPage()),
          );
        }, child: Text("Events"))
         // _selectedDay != null ? _buildEventsList() : Container(),
        ],
      ),
    );
  }



  Future<List<Map<String, dynamic>>> _fetchEvents(DateTime? date) async {
    List<Map<String, dynamic>> events = [];

    if (date != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('date', isEqualTo: date)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        events.add(data);
      }
    }

    setState(() {
      _events[date!] = events;
    });

    return events;
  }

  void _addEvent() {
    if (_selectedDay != null && _eventController.text.isNotEmpty) {
      setState(() {
        _events[_selectedDay!] = [
          {'event': _eventController.text}
        ];
      });

      _saveEventToFirebase(_selectedDay!, _eventController.text);
      _eventController.clear();
    }
  }

  void _saveEventToFirebase(DateTime date, String event) {
    FirebaseFirestore.instance.collection('events').doc(date.toString()).set({
      'date': date,
      'event': event,
    });
  }

  void _deleteEvent(DateTime date, String event) {
    FirebaseFirestore.instance
        .collection('events')
        .doc(date.toString())
        .update({
      'event': FieldValue.arrayRemove([event]),
    });

    // After deletion, refresh the events list
    _fetchEvents(date);
  }
}

void main() {
  runApp(MaterialApp(
    home: CalendarPage(),
  ));
}
