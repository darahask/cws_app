import 'package:flutter/material.dart';
import 'package:cws_app/dm_classes/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

final fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class Chat extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chat> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  String uistatus = 'loading';
  String devstatus = 'loading';
  String status = 'Ui Admin and Head';

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
            uistatus = (snap.data['uistatus'] == null || snap.data['uistatus'] == '')
                ? 'null'
                : snap.data['uistatus'];
            devstatus = (snap.data['devstatus'] == null)
                ? 'null'
                : snap.data['devstatus'];
          }
          if (uistatus == 'loading' && devstatus == 'loading') {
            status = 'loading';
          } else if (uistatus.toLowerCase() != 'done') {
            status = 'Chat with UI Designer and Head';
          } else {
            if(uistatus.toLowerCase() == 'done' && devstatus.toLowerCase() == 'done')
              status = 'Chat with Admin';
            else
              status = 'Chat with Developer Manager and Admin';
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
        appBar: AppBar(
          title: FittedBox(
              child: Text(
              status,
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
          ),
          leading: Icon(Icons.message),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.phone),
              onPressed: () async{
                const url = 'tel:+917080855524';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (loggedInUser != null) ? MessagesStream() : Container(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      fireStore
                          .collection('Client')
                          .document(loggedInUser.uid)
                          .collection('messages')
                          .add({
                        'text': messageText,
                        'sender': loggedInUser == null
                            ? 'Anonymous'
                            : loggedInUser.email,
                        'timestamp':
                            DateTime.now().millisecondsSinceEpoch.toString(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
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
      stream: fireStore
          .collection('Client')
          .document(loggedInUser.uid)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
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
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          final currentUser =
              loggedInUser == null ? 'Anonymous' : loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Color(0xff034198) : Color(0xff09a5e0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
