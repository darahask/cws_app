import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      salary = 'loading',
      salaryPackage = 'loading';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
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
          salary =
              (snap.data['salary'] == null) ? 'Set data' : snap.data['salary'];
          salaryPackage =
              (snap.data['salpkg'] == null) ? 'Set data' : snap.data['salpkg'];
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            infoData(
              presentwork,
              'Assigned Work',
            ),
            infoData(
              salaryPackage,
              'Salary Package',
            ),
            infoData(
              salary,
              'Salary Credited',
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
              height: 7,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                title: TextField(
                  decoration: InputDecoration(
                    labelText: 'Present Work Assignment'
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: (){

                  },
                ),
              ),
            ),
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
}
