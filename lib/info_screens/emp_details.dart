import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/employee_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final fireStore = Firestore.instance;
FirebaseUser loggedInUser;
String name='loading',presentwork='loading',futurework='loading',salary='loading';

class AdminEmployeeDash extends StatefulWidget {

  final String uid,type;
  AdminEmployeeDash({this.uid, this.type});



  @override
  _AdminEmployeeDashState createState() => _AdminEmployeeDashState();
}

class _AdminEmployeeDashState extends State<AdminEmployeeDash> {

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try {
     var snap = await Firestore.instance.collection(widget.type).document(widget.uid).get();
     setState(() {
       if(snap!=null){
         name = snap.data['name'];
         presentwork = (snap.data['presentwork'] == null)?'Set data':snap.data['presentwork'];
         futurework = (snap.data['futurework'] == null)?'Set data':snap.data['futurework'];
         salary = (snap.data['salary'] == null)?'Set data':snap.data['salary'];
       }
     });
    }catch(e){
      print(e);
    }
  }

  String pw,fw,sal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name),),
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Container(
              margin: EdgeInsets.only(top: 16,),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: <Widget>[
                  Text('Present Work:'),
                  Text(presentwork),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:32.0),
                    child: TextField(
                      onChanged: (s){pw = s;},
                    ),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    child: Text('Change'),
                    onPressed: () async{
                      try{
                        await Firestore.instance.collection(widget.type).document(widget.uid).updateData({'presentwork':pw});
                        getCurrentUser();
                      }catch(e){
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Container(
              margin: EdgeInsets.only(top: 16,),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: <Widget>[
                  Text('Salary:'),
                  Text(salary),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:32.0),
                    child: TextField(
                      onChanged: (s){sal = s;},
                    ),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    child: Text('Change'),
                    onPressed: () async{
                      try{
                        await Firestore.instance.collection(widget.type).document(widget.uid).updateData({'salary':sal});
                        getCurrentUser();
                      }catch(e){
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Container(
              margin: EdgeInsets.only(top: 16,),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[4],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: <Widget>[
                  Text('Future Work:'),
                  Text(futurework),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:32.0),
                    child: TextField(
                      onChanged: (s){fw = s;},
                    ),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    child: Text('Change'),
                    onPressed: () async{
                      try{
                        await Firestore.instance.collection(widget.type).document(widget.uid).updateData({'futurework':fw});
                        getCurrentUser();
                      }catch(e){
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
