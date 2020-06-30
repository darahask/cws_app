import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesRegister extends StatefulWidget {
  @override
  _SalesRegisterState createState() => _SalesRegisterState();
}

class _SalesRegisterState extends State<SalesRegister> {

  final _auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  String name,email,password,mobile,city;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff09a5e0),Color(0xff034198),],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40,),
                  new InputWidget(name: 'Name',data: Icons.person,onpressed: (val){ name = val;},),
                  SizedBox(height: 10,),
                  new InputWidget(name: 'Email',data: Icons.mail,onpressed: (val){ email = val;},),
                  SizedBox(height: 10,),
                  new InputWidget(name: 'Password',data: Icons.lock,onpressed: (val){ password = val;},),
                  SizedBox(height: 10,),
                  new InputWidget(name: 'Mobile',data: Icons.phone_android,onpressed: (val){ mobile = val;},),
                  SizedBox(height: 10,),
                  new InputWidget(name: 'City',data: Icons.location_on,onpressed: (val){ city = val;},),
                  SizedBox(height: 10,),
                  new InputWidget(name: 'Confirm Password',data: Icons.lock,onpressed: (val){ password = val;},),
                  SizedBox(height: 60,),
                  GestureDetector(
                    onTap: () async{
                      try{
                        setState(() {
                          loading = true;
                        });
                        var x = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        if(x!=null){
                          var user = await _auth.currentUser();
                          await firestore.collection('Client').document(user.uid).setData({
                            'name': name,
                            'mobile': mobile,
                            'city' : city,
                            'sd': DateTime.now().millisecondsSinceEpoch
                          });
                          setState(() {
                            loading = false;
                          });
                          _auth.signOut();
                          Navigator.pop(context);
                        }
                      }
                      catch(e){
                        print(e);
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class InputWidget extends StatelessWidget {

  final name,data,onpressed;
  InputWidget({this.name,this.data,this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        onChanged: onpressed,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: name,
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
          icon: Icon(
            data,
            size: 30,
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}