import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

final fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class ClientStatus extends StatefulWidget {
  @override
  _ClientStatusState createState() => _ClientStatusState();
}

class _ClientStatusState extends State<ClientStatus> {
  String name = 'loading',
      overalldevstatus = 'loading',
      uistatus = 'loading',
      devstatus = 'loading',
      mobile = 'loading';
  int payper = 0, proper = 0;
  String uiimguri = 'loading', devimguri = 'loading';

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
            .collection('Client')
            .document(loggedInUser.uid)
            .get();
        setState(() {
          if (snap != null) {
            name = (snap.data['name'] == null) ? 'null' : snap.data['name'];
            overalldevstatus = (snap.data['overalldevstatus'] == null)
                ? 'null'
                : snap.data['overalldevstatus'];
            uistatus = (snap.data['uistatus'] == null)
                ? 'null'
                : snap.data['uistatus'];
            devstatus = (snap.data['devstatus'] == null)
                ? 'null'
                : snap.data['devstatus'];
            payper =
                (snap.data['payper'] == null) ? 'null' : snap.data['payper'];
            proper =
                (snap.data['proper'] == null) ? 'null' : snap.data['proper'];
            uiimguri = (snap.data['uiimageuri'] == null)
                ? 'null'
                : snap.data['uiimageuri'];
            devimguri = (snap.data['devimageuri'] == null)
                ? 'null'
                : snap.data['devimageuri'];
            mobile =
                (snap.data['mobile'] == null) ? 'null' : snap.data['mobile'];
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: Color(0xff034198),
                        fontFamily: 'OpenSans'),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Id: '+ ((loggedInUser != null)?loggedInUser.uid:'loading'),
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              Center(
                child: Text(
                  'Mobile: '+mobile,
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              StatusContainer(
                  payper: payper,
                  proper: proper,
                  overalldevstatus: overalldevstatus),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            const url = 'tel:+917080855524';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: kElevationToShadow[2],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.phone,
                                      size: 60,
                                    )),
                                Expanded(
                                  child: Text(
                                    'Call',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            const url = 'sms:+917080855524';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: kElevationToShadow[2],
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.message,
                                      size: 60,
                                    )),
                                Expanded(
                                  child: Text(
                                    'Message',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: kElevationToShadow[2],
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'UI Design',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          gradient: LinearGradient(
                            colors: [Color(0xff09a5e0), Color(0xff034198)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            uistatus,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Image(
                image: NetworkImage(uiimguri),
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: kElevationToShadow[2],
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Development',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          gradient: LinearGradient(
                            colors: [Color(0xff09a5e0), Color(0xff034198)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            devstatus,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Image(
                image: NetworkImage(devimguri),
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusContainer extends StatelessWidget {
  final String overalldevstatus;
  final int payper, proper;

  StatusContainer({this.overalldevstatus, this.payper, this.proper});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kElevationToShadow[3],
        borderRadius: BorderRadius.circular(10),
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
                          value: proper / 100,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff034198)),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                          value: payper / 100,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff09a5e0)),
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
                        child: Text(
                          'Process: ' + proper.toString() + '%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Payment: ' + payper.toString() + '%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        overalldevstatus,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
