import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/dm_classes/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final fireStore = Firestore.instance;

class SupportChat extends StatefulWidget {
  final String uid;
  final FirebaseUser loggedInUser;
  final String type;
  SupportChat({this.uid, this.loggedInUser, @required this.type});

  @override
  _SupportChatState createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  FirebaseUser loggedInUser;
  final messageTextController = TextEditingController();
  String messageText;
  String uid;
  bool initstate = true;

  void getCurrentUser() async{
    try {
      var user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
          uid = loggedInUser.uid;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    if(loggedInUser == null && initstate){
      getCurrentUser();
    }
    initstate = false;
    super.didChangeDependencies();
  }

  getUser(){
    if(widget.loggedInUser == null)
      return loggedInUser;
    return widget.loggedInUser;
  }

  getUid(){
    if(widget.uid == null)
      return uid;
    return widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ClientSupportManager'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          (loggedInUser == null)?Container():MessagesStream(getUser(), getUid(), widget.type),
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
                        .collection(widget.type)
                        .document(getUid())
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
    );
  }
}

class MessagesStream extends StatelessWidget {
  final loggedInUser;
  final uid;
  final type;
  MessagesStream(this.loggedInUser, this.uid, this.type);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore
          .collection(type)
          .document(uid)
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
