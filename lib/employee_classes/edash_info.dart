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
  String pw = 'Loading', fw = "Loading", sal = '0.0', name = 'Loading',salaryPkg = 'Loading';
  int attendance = 0;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      var user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        var snap = await Firestore.instance
            .collection(widget.type)
            .document(loggedInUser.uid)
            .get();
        setState(() {
          if (snap != null) {
            pw = (snap.data['presentwork'] == null)
                ? 'null'
                : snap.data['presentwork'];
            fw = (snap.data['futurework'] == null)
                ? 'null'
                : snap.data['futurework'];
            sal = (snap.data['salary'] == null) ? '0.0' : snap.data['salary'];
            name = (snap.data['name'] == null) ? 'null' : snap.data['name'];
            salaryPkg = (snap.data['salarypackage'] == null) ? 'null' : snap.data['salarypackage'];
            attendance = (snap.data['attendance'] == null) ? 0 : snap.data['attendance'];
          }
        });
      }
    } catch (e) {
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
                  'SalaryPackage: ' + salaryPkg + '/month',
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
                  'Attendance: ' + attendance.toString(),
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, letterSpacing: .6),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              height: MediaQuery.of(context).size.height / 3.4,
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
                      double.parse(sal).truncate().toString(),
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff034198),
                          letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String url = 'mailto:mcogentweb@gmail.com?subject=$pw submission';
          if (await canLaunch(url)) {
            await launch(url);
            await Firestore.instance
                .collection(widget.type)
                .document(loggedInUser.uid)
                .updateData(
              {
                'presentworkstatus':
                    DateTime.now().millisecondsSinceEpoch.toString(),
                'attendance': attendance + 1,
              },
            );
          } else {
            throw 'Could not launch $url';
          }
          fireStore
              .collection(widget.type)
              .document(loggedInUser.uid)
              .collection('messages')
              .add(
            {
              'text':
                  "Today's work is completed please check the mail, Thankyou.\nID: ${loggedInUser.uid}",
              'sender': loggedInUser == null ? 'Anonymous' : loggedInUser.email,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          );
        },
        elevation: 4,
        child: Icon(
          Icons.assignment_turned_in,
        ),
      ),
    );
  }
}
