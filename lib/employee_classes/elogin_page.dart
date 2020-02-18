import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/employee_classes/einfo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ELoginPage extends StatefulWidget {
  @override
  _ELoginPageState createState() => _ELoginPageState();
}

class _ELoginPageState extends State<ELoginPage> {

  final _auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  bool loading = false;
  String email,password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 80),
                Image(
                  width: MediaQuery.of(context).size.width / 1.5,
                  image: AssetImage('images/darklogo.png'),
                ),
                SizedBox(height: 10,),
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    onChanged: (val){email = val;},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Email or ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
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
                    onChanged: (val){password = val;},
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Passcode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(35),
                  child: GestureDetector(
                    onTap: ()async {
                      try{
                        setState(() {
                          loading = true;
                        });
                        var x = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(x!=null){
                          var user = await _auth.currentUser();
                          var data = await firestore.collection('Sales Employee').getDocuments();
                          var data2 = await firestore.collection('Design Employee').getDocuments();
                          var data3 = await firestore.collection('Development Employee').getDocuments();
                          print(user.uid);
                          for( var doc in data.documents){
                            print(doc.documentID);
                            if(doc.documentID == user.uid){
                              print(doc.documentID);
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>EmployeeInfoPage('sales')));
                            }
                          }
                          for( var doc in data2.documents){
                            if(doc.documentID == user.uid){
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>EmployeeInfoPage('design')));
                            }
                          }
                          for( var doc in data3.documents){
                            if(doc.documentID == user.uid){
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>EmployeeInfoPage('development')));
                            }
                          }
                          setState(() {
                            loading=false;
                          });
                        }
                      }catch(e){
                        print(e);
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10),),
                        gradient: LinearGradient(
                          colors: [Color(0xff09a5e0), Color(0xff034198)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22
                          ),
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
