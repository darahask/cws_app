import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

final fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class EmployeeDashboard extends StatefulWidget {

  EmployeeDashboard(this.type);
  final String type;

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {

  String pw = 'Loading',fw = "Loading",sal = 'Loading';
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try {
      var user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        var snap = await Firestore.instance.collection(widget.type).document(loggedInUser.uid).get();
        setState(() {
          if(snap!=null){
            pw = (snap.data['presentwork'] == null)?'null':snap.data['presentwork'];
            fw = (snap.data['futurework'] == null)?'null':snap.data['futurework'];
            sal = (snap.data['salary'] == null)?'null':snap.data['salary'];
          }
        });
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "DASHBOARD",
                style: TextStyle(
                  color: Color(0xff034198),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: .7,
                  shadows: kElevationToShadow[4],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'FutureWork: ' + fw,
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, letterSpacing: .6),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'PresentWork: ' + pw,
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, letterSpacing: .6),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Salary: (In Rupees)',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      sal,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff034198),
                        letterSpacing: 1
                      ),
                    ),

                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var now = DateTime.now();
          String url = 'mailto:mcogentweb@gmail.com?subject=$pw submission';
          if (await canLaunch(url)) {
            await launch(url);
            await Firestore.instance.collection(widget.type).document(loggedInUser.uid).updateData({'presentworkstatus':'submitted on ($now)'});
          } else {
            throw 'Could not launch $url';
          }
        },
        elevation: 4,
        child: Icon(
          Icons.assignment_turned_in,
        ),
      ),
    );
  }
}
