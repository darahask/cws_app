import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cws_app/info_screens/admin_client.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cws_app/dm_classes/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

final fireStore = Firestore.instance;

class DataEditor extends StatefulWidget {
  final String uid;
  DataEditor(this.uid);

  @override
  _DataEditorState createState() => _DataEditorState();
}

class _DataEditorState extends State<DataEditor> {

  final messageTextController = TextEditingController();
  final messageTextController2= TextEditingController();
  final messageTextController3 = TextEditingController();
  final messageTextController4 = TextEditingController();
  final messageTextController5 = TextEditingController();
  String overalldevstatus='null',uistatus='null',devstatus='null',mobile='null';
  int payper=0, proper=0;

  final _storage = FirebaseStorage.instance;
  File _image;
  String uri;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future uploadPic() async {
    StorageReference reference = _storage.ref().child(_image.path.substring(_image.path.lastIndexOf('/')+1));
    StorageUploadTask uploadTask = reference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    uri = await reference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DataEditor'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: messageTextController,
                  onChanged: (value) {
                    proper = int.parse(value);
                  },
                  decoration: kMessageTextFieldDecoration.copyWith(
                    hintText: 'Process Percentage',
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  messageTextController.clear();
                  fireStore.collection('Client').document(widget.uid).updateData({
                    'proper':proper,
                  });
                },
                child: Text(
                  'Send',
                  style: kSendButtonTextStyle,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: messageTextController2,
                  onChanged: (value) {
                    payper = int.parse(value);
                  },
                  decoration: kMessageTextFieldDecoration.copyWith(
                    hintText: 'Payment Percentage',
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  messageTextController2.clear();
                  fireStore.collection('Client').document(widget.uid).updateData({
                    'payper':payper,
                  });
                },
                child: Text(
                  'Send',
                  style: kSendButtonTextStyle,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageTextController3,
                  onChanged: (value) {
                    overalldevstatus = value;
                  },
                  decoration: kMessageTextFieldDecoration.copyWith(
                    hintText: 'OverAll Dev. Status',
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  messageTextController3.clear();
                  fireStore.collection('Client').document(widget.uid).updateData({
                    'overalldevstatus':overalldevstatus,
                  });
                },
                child: Text(
                  'Send',
                  style: kSendButtonTextStyle,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageTextController4,
                  onChanged: (value) {
                    uistatus = value;
                  },
                  decoration: kMessageTextFieldDecoration.copyWith(
                    hintText: 'Ui Status',
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  messageTextController4.clear();
                  fireStore.collection('Client').document(widget.uid).updateData({
                    'uistatus':uistatus,
                  });
                },
                child: Text(
                  'Send',
                  style: kSendButtonTextStyle,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageTextController5,
                  onChanged: (value) {
                    devstatus = value;
                  },
                  decoration: kMessageTextFieldDecoration.copyWith(
                    hintText: 'Development Status',
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  messageTextController5.clear();
                  fireStore.collection('Client').document(widget.uid).updateData({
                    'devstatus':devstatus
                  });
                },
                child: Text(
                  'Send',
                  style: kSendButtonTextStyle,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: ()async{
                  await getImage();
                  await uploadPic();
                  fireStore.collection('Client').document(widget.uid).updateData({
                    'uiimageuri':uri,
                  });
                },
                child: Text('Upload UI Image'),
              ),
              FlatButton(
                onPressed: ()async{
                  await getImage();
                  await uploadPic();
                  fireStore.collection('Client').document(widget.uid).updateData({
                    'devimageuri':uri,
                  });
                },
                child: Text('Upload Dev. Image'),
              ),
              FlatButton(
                onPressed: () async {
                  var snap = await Firestore.instance.collection('Client').document(widget.uid).get();
                  if(snap!=null){
                    mobile = (snap.data['mobile'] == null)?'null':snap.data['mobile'];
                  }
                  String url = 'tel:$mobile';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('Call Client'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
