import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/adminsprivate/adminschat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashInfo extends StatefulWidget {

  @override
  _DashInfoState createState() => _DashInfoState();
}

class _DashInfoState extends State<DashInfo> {

  final _auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  String type;

  void getType() async{
    try{
        var user = await _auth.currentUser();
        var data = await firestore.collection('Over all Admin').getDocuments();
        var data2 = await firestore.collection('Design Admin').getDocuments();
        var data3 = await firestore.collection('Development Admin').getDocuments();
        for( var doc in data.documents){
          print(doc.documentID);
          if(doc.documentID == user.uid){
            print(doc.documentID);
            setState(() {
              type = 'overall';
            });
          }
        }
        for( var doc in data2.documents){
          if(doc.documentID == user.uid){
            setState(() {
              type = 'design';
            });
          }
        }
        for( var doc in data3.documents){
          if(doc.documentID == user.uid){
            setState(() {
              type = 'development';
            });
          }
        }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    getType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      'DASHBOARD',
                      style: TextStyle(
                          color: Color(0xff034198),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        shadows: kElevationToShadow[4],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        boxShadow: kElevationToShadow[8],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        gradient: LinearGradient(
                          colors: [Color(0xff09a5e0), Color(0xff034198)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Total Number of Employee in - ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                          boxShadow: kElevationToShadow[8],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white),
                      child: Center(
                        child: Text(
                          '5 Employees are Active Now - names \n\n15 Employees are offline - ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: kElevationToShadow[8],
                        gradient: LinearGradient(
                          colors: [Color(0xff09a5e0), Color(0xff034198)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Total Employee completed their task today',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  (type == 'overall')?ChatBox(type):Container(),
                  (type == 'overall')?ChatBox2(type):Container(),
                  (type == 'design')?ChatBox(type):Container(),
                  (type == 'development')?ChatBox(type):Container(),
                  SizedBox(height: 16,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBox extends StatefulWidget {
   final String type;
   ChatBox(this.type);

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {

  String name='loading',chatcode;

  void decideInit(String type){
    if(type == 'overall'){
      name = 'Design Admin';
      chatcode = 'DesignAll';
    }else if( type == 'design'){
      name = 'Prithvi Sir';
      chatcode = 'DesignAll';
    }else{
      print(widget.type);
      name = 'Prithvi Sir';
      chatcode = 'DevelopAll';
    }

  }

  @override
  void initState() {
    decideInit(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminsChat(chatcode)));
        },
        child: Container(
          height: 90,
          decoration: BoxDecoration(
              boxShadow: kElevationToShadow[4],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.person,
                color: Colors.black,
                size: 60,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBox2 extends StatefulWidget {
  final String type;
  ChatBox2(this.type);

  @override
  _ChatBox2State createState() => _ChatBox2State();
}

class _ChatBox2State extends State<ChatBox2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminsChat('DevelopAll')));
        },
        child: Container(
          height: 90,
          decoration: BoxDecoration(
              boxShadow: kElevationToShadow[4],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.person,
                color: Colors.black,
                size: 60,
              ),
              Text(
                'Development Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}