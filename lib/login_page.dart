import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  bool loading = false;
  String email, password;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                Image(
                  width: MediaQuery.of(context).size.width / 1.4,
                  image: AssetImage('images/darklogo.png'),
                ),
                Text(
                  'Welcome',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      fontFamily: 'OpenSans'),
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    onChanged: (val) {
                      email = val;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Email',
                      fillColor: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    obscureText: true,
                    onChanged: (val) {
                      password = val;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      labelText: 'Passcode',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(35),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        setState(() {
                          loading = true;
                        });
                        var x = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (x != null) {
                          var user = await _auth.currentUser();
                          var data = await firestore
                              .collection('Over all Admin')
                              .getDocuments();
                          var data2 = await firestore
                              .collection('Design Admin')
                              .getDocuments();
                          var data3 = await firestore
                              .collection('Development Admin')
                              .getDocuments();
                          print(user.uid);
                          for (var doc in data.documents) {
                            print(doc.documentID);
                            if (doc.documentID == user.uid) {
                              print(doc.documentID);
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InfoMain(type: 'overall')));
                            }
                          }
                          for (var doc in data2.documents) {
                            if (doc.documentID == user.uid) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InfoMain(type: 'design')));
                            }
                          }
                          for (var doc in data3.documents) {
                            if (doc.documentID == user.uid) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InfoMain(type: 'development')));
                            }
                          }
                          setState(() {
                            loading = false;
                          });
                        } else {
                          setState(() {
                            loading = false;
                          });
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Wrong Credentials or no internet connection'),
                            ),
                          );
                        }
                      } catch (e) {
                        setState(() {
                          loading = false;
                        });
                        print(e);
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                                'Wrong Credentials or no internet connection'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [Color(0xff09a5e0), Color(0xff034198)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
