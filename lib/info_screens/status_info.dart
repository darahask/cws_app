import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/client_classes/cstatus_info.dart';
import 'package:cws_app/info_screens/client_data_editor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class StatusInfo extends StatefulWidget {
  @override
  _StatusInfoState createState() => _StatusInfoState();
}

class _StatusInfoState extends State<StatusInfo> {

  final _auth = FirebaseAuth.instance;
  String messageText;

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
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Working Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Color(0xff034198),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MessagesStream(),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('Client').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff034198),
              ),
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<StatusContainer> container = [];
        for (var snap in messages) {

          String overalldevstatus = (snap.data['overalldevstatus'] == null)?'null':snap.data['overalldevstatus'];
          String name = (snap.data['name'] == null)?'null':snap.data['name'];
          int payper = (snap.data['payper'] == null)?0:snap.data['payper'];
          int proper = (snap.data['proper'] == null)?0:snap.data['proper'];
          final c = StatusContainer(payper:payper,proper:proper,overalldevstatus:overalldevstatus,uid: snap.documentID,name:name);

          container.add(c);
        }
        return Expanded(
          child: ListView(
//            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: container,
          ),
        );
      },
    );
  }
}

class StatusContainer extends StatelessWidget {

  final String overalldevstatus,uid,name;
  final int payper, proper;

  StatusContainer({this.overalldevstatus, this.payper, this.proper,this.uid,this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DataEditor(uid)));
        },
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: kElevationToShadow[2],
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Image(
                  image: AssetImage('images/darklogo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(
                              value: proper/100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff034198)),
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearProgressIndicator(
                              value: payper/100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff09a5e0)),
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Process-' + proper.toString()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Payment-' + payper.toString()),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(name),
                        Text(overalldevstatus),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
