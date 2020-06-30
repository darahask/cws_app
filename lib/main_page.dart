import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/client_classes/cLogin_page.dart';
import 'package:cws_app/client_classes/client_info.dart';
import 'package:cws_app/employee_classes/elogin_page.dart';
import 'package:cws_app/login_page.dart';
import 'package:cws_app/supportclasses/support_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  bool loading = true;

  void autoLogin()async{
    var user = await _auth.currentUser();
    if(user != null){
       if((await _fireStore.collection('Client').document(user.uid).get()).exists){
         setState(() {loading=false;});
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ClientLogin(signedIn:true)));
       }else if((await _fireStore.collection('Design Admin').document(user.uid).get()).exists||
       (await _fireStore.collection('Development Admin').document(user.uid).get()).exists ||
       (await _fireStore.collection('Over all Admin').document(user.uid).get()).exists){
         setState(() {loading=false;});
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage(signedIn: true,)));
       }else if((await _fireStore.collection('Design Employee').document(user.uid).get()).exists||
       (await _fireStore.collection('Development Employee').document(user.uid).get()).exists ||
       (await _fireStore.collection('Sales Employee').document(user.uid).get()).exists){
         setState(() {loading=false;});
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ELoginPage(signedIn: true,)));
       }else{
         setState(() {loading=false;});
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SupportLogin(signedIn: true,)));
       }
    }
    setState(() {loading=false;});
  }

  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading)?Center(child: CircularProgressIndicator()):Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff09a5e0), Color(0xff034198)],
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.6,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(50),),
                  boxShadow: kElevationToShadow[8]),
              child: Center(
                child: Image(
                  width: MediaQuery.of(context).size.width / 1.3,
                  image: AssetImage('images/darklogo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Dreams We Fullfill',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ClientLogin()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(14),
                        right: Radius.circular(14),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Client',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                            letterSpacing: 0.6
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(14),
                        right: Radius.circular(14),
                      ),
                    ),
                    child: Center(
                        child: Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6
                      ),
                    ),),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ELoginPage()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(14),
                        right: Radius.circular(14),
                      ),
                    ),
                    child: Center(
                        child: Text(
                      'Employee',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6
                      ),
                    ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SupportLogin()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(14),
                        right: Radius.circular(14),
                      ),
                    ),
                    child: Center(
                        child: Text(
                      'Support',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6
                      ),
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
