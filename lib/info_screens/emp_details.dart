import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminEmployeeDash extends StatefulWidget {
  final String uid, type;
  AdminEmployeeDash({this.uid, this.type});

  @override
  _AdminEmployeeDashState createState() => _AdminEmployeeDashState();
}

class _AdminEmployeeDashState extends State<AdminEmployeeDash> {
  final fireStore = Firestore.instance;
  FirebaseUser loggedInUser;
  String name = 'loading',
      presentwork = 'loading',
      futurework = 'loading',
      salary = '0.0',
      salaryPackage = '0.0',
      presentWorkStatus = '0';
  int attendance = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      loggedInUser = await FirebaseAuth.instance.currentUser();
      var snap = await Firestore.instance
          .collection(widget.type)
          .document(widget.uid)
          .get();
      setState(() {
        if (snap != null) {
          name = snap.data['name'];
          presentwork = (snap.data['presentwork'] == null)
              ? 'Set data'
              : snap.data['presentwork'];
          futurework = (snap.data['futurework'] == null)
              ? 'Set data'
              : snap.data['futurework'];
          salary = (snap.data['salary'] == null) ? '0.0' : snap.data['salary'];
          salaryPackage = (snap.data['salarypackage'] == null)
              ? '0.0'
              : snap.data['salarypackage'];
          attendance =
              (snap.data['attendance'] == null) ? 0 : snap.data['attendance'];
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () async {
              var now = DateFormat('dd/MM/yyyy').format(DateTime.now());
              String url =
                  'mailto:${loggedInUser.email}?subject=$now Present work mail';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            infoDataWithReset(
              'Attendance: ' + attendance.toString() + ' days/month',
              ((DateTime.now().millisecondsSinceEpoch -
                          int.parse(presentWorkStatus)) <=
                      86400)
                  ? 'Yesterdays Work Subbmited on mail'
                  : 'Work delayed or not submitted',
                'attendance'
            ),
            infoData(
              presentwork,
              'Assigned Work',
            ),
            infoData(
              salaryPackage,
              'Salary Package',
            ),
            infoDataWithReset(
              salary,
              'Salary Credited',
              'salary'
            ),
            infoData(
              futurework,
              'Future Work',
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              thickness: 2,
              color: Colors.black87,
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                title: TextField(
                  decoration:
                      InputDecoration(labelText: 'Present Work Assignment'),
                  onChanged: (val) {
                    presentwork = val;
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    fireStore
                        .collection(widget.type)
                        .document(widget.uid)
                        .setData({
                      'presentwork': presentwork,
                    }, merge: true);
                    setState(() {});
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                title: TextField(
                  onChanged: (val) {
                    futurework = val;
                  },
                  decoration:
                      InputDecoration(labelText: 'Future Work Assigment'),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    fireStore
                        .collection(widget.type)
                        .document(widget.uid)
                        .setData({
                      'futurework': futurework,
                    }, merge: true);
                    setState(() {});
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                title: Text(
                  'Today\'s Salary: ${double.parse(salaryPackage) / 31}',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    fireStore
                        .collection(widget.type)
                        .document(widget.uid)
                        .setData({
                      'salary': (double.parse(salary) +
                              (double.parse(salaryPackage) / 31))
                          .toString(),
                    }, merge: true);
                    setState(() {
                      salary = (double.parse(salary) +
                              (double.parse(salaryPackage) / 31))
                          .toString();
                    });
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                title: TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Update Salary Package'),
                  onChanged: (value) {
                    salaryPackage = value;
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    fireStore
                        .collection(widget.type)
                        .document(widget.uid)
                        .setData({
                      'salarypackage': salaryPackage,
                    }, merge: true);
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget infoData(String data, String type) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kElevationToShadow[4],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ListTile(
        title: Text(data),
        subtitle: Text(type),
      ),
    );
  }

  Widget infoDataWithReset(String data, String type, String key) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kElevationToShadow[4],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ListTile(
        title: Text(data),
        subtitle: Text(type),
        trailing: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            fireStore.collection(widget.type).document(widget.uid).setData({
              key : 0,
            }, merge: true);
            setState(() {
              if(key == 'salary'){
                salary = '0';
              }else{
                attendance = 0;
              }
            });
          },
        ),
      ),
    );
  }
}
