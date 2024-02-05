import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourFirebaseDataPage extends StatefulWidget {
  @override
  _YourFirebaseDataPageState createState() => _YourFirebaseDataPageState();
}

class _YourFirebaseDataPageState extends State<YourFirebaseDataPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              searchUsers(_searchController.text);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search user...',
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
              child: Text('No matching users found.'),
            )
                : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                var userData = _filteredUsers[index];
                var division = userData['div'];
                var name = userData['name'];
                var rollNumber = userData['roll'];

                return ListTile(
                  title: Text('$name - $division'),
                  subtitle: Text('Roll Number: $rollNumber'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchUsers(String query) {
    setState(() {
      _filteredUsers = [];
    });

    if (query.isNotEmpty) {
      // Convert the query to lowercase for case-insensitive matching
      query = query.toLowerCase();

      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          var userData = doc.data() as Map<String, dynamic>;

          // Convert user data to lowercase for case-insensitive matching
          var name = userData['name'].toString().toLowerCase();
          var division = userData['div'].toString().toLowerCase();
          var rollNumber = userData['roll'].toString().toLowerCase();

          // Check if any part of the user data matches the query
          if (name.contains(query) ||
              division.contains(query) ||
              rollNumber.contains(query)) {
            setState(() {
              _filteredUsers.add(userData);
            });
          }
        }
      });
    }
  }
}
