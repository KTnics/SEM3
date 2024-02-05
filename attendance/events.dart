import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Page'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('date', isGreaterThanOrEqualTo: Timestamp.now())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var events = snapshot.data!.docs;

          if (events.isEmpty) {
            return Center(
              child: Text('No future events available.'),
            );
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var eventData = events[index].data() as Map<String, dynamic>;
              var event = eventData['event'];
              var date = (eventData['date'] as Timestamp).toDate();

              return ListTile(
                title: Text('Event: $event'),
                subtitle: Text('Date: ${date.toLocal()}'),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EventsPage(),
  ));
}
