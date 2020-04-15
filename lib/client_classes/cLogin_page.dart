import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/client_classes/client_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ClientLogin extends StatefulWidget {
  @override
  _ClientLoginState createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {

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
                    fontFamily: 'OpenSans'
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    onChanged: (val){email = val;},
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
                    onChanged: (val){password = val;},
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
                    onTap: ()async{
                      try{
                        setState(() {
                          loading = true;
                        });
                        var x = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(x!=null){
                          var user = await _auth.currentUser();
                          var data = await firestore.collection('Client').getDocuments();
                          for( var doc in data.documents){
                            print(doc.documentID);
                            if(doc.documentID == user.uid){
                              print(doc.documentID);
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>ClientInfo()));
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
                      height: 60,
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
