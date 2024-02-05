import 'package:final_sem_project/attendance/calender.dart';
import 'package:final_sem_project/attendance/firebase_data_page.dart';

import 'StudentList.dart';
import 'attendance/HomeA.dart';
import 'posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'model.dart';

class Teacher extends StatefulWidget {
  String id;
  Teacher({required this.id});
  @override
  _TeacherState createState() => _TeacherState(id: id);
}

class _TeacherState extends State<Teacher> {
  String id;
  var rooll;
  var emaill;
  UserModel loggedInUser = UserModel();

  _TeacherState({required this.id});

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    }).whenComplete(() {
      CircularProgressIndicator();
      setState(() {
        emaill = loggedInUser.email.toString();
        rooll = loggedInUser.wrool.toString();
        id = loggedInUser.uid.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => studentList(),
                  ),
                );
              },
              child: Text("List of Parents"),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[900],
                onPrimary: Colors.white,
                minimumSize: Size(150, 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => posts(),
                  ),
                );
              },
              child: Text("Post"),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[900],
                onPrimary: Colors.white,
                minimumSize: Size(150, 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Homea(),
                  ),
                );
              },
              child: Text("Take Attendance"),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[900],
                onPrimary: Colors.white,
                minimumSize: Size(150, 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => YourFirebaseDataPage(),
                  ),
                );
              },
              child: Text("Student List"),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[900],
                onPrimary: Colors.white,
                minimumSize: Size(150, 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(),
                  ),
                );
              },
              child: Text("Calendar"),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[900],
                onPrimary: Colors.white,
                minimumSize: Size(150, 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
