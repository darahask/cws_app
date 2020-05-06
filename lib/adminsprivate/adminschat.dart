import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cws_app/dm_classes/constants.dart';
import 'package:flutter/material.dart';

class AdminsChat extends StatefulWidget {
  final String type;
  AdminsChat(this.type);

  @override
  _AdminsChatState createState() => _AdminsChatState();
}

class _AdminsChatState extends State<AdminsChat> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  final fireStore = Firestore.instance;
  FirebaseUser loggedInUser;

  void getCurrentUser() async {
    try {
      var user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Prithvi Sir'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          (loggedInUser != null)
              ? StreamBuilder<QuerySnapshot>(
                  stream: fireStore
                      .collection(widget.type)
                      .document(loggedInUser.uid)
                      .collection('messagesprivate')
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

                      final currentUser = loggedInUser == null
                          ? 'Anonymous'
                          : loggedInUser.email;

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
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        children: messageBubbles,
                      ),
                    );
                  },
                )
              : Container(),
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
                        .document(loggedInUser.uid)
                        .collection('messagesprivate')
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
