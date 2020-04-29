import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/supportclasses/supportchat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class SupportDev extends StatefulWidget {
  @override
  _SupportDevState createState() => _SupportDevState();
}

class _SupportDevState extends State<SupportDev> {
  final _auth = FirebaseAuth.instance;
  String messageText;

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
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.people),
          title: Text(
            'Clients',
            style:
                TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            MessagesStream(),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('Development Admin').snapshots(),
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
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final cliname = message.data['name'];
          final cliuid = message.documentID;

          final messageBubble = MessageBubble(name: cliname, uid: cliuid);

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String name, uid;
  MessageBubble({this.name, this.uid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SupportChat(uid: uid, loggedInUser: loggedInUser)));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: kElevationToShadow[2],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Image(
              image: AssetImage('images/darklogo.png'),
            ),
            title: Text(name),
            subtitle: FittedBox(
              child: Text(uid),
            ),
          ),
        ),
      ),
    );
  }
}
