import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final fireStore = Firestore.instance;

class DataEditor extends StatefulWidget {
  final String uid;
  DataEditor(this.uid);

  @override
  _DataEditorState createState() => _DataEditorState();
}

class _DataEditorState extends State<DataEditor> {
  String overalldevstatus = 'Select Item',
      uistatus = 'Select Item',
      devstatus = 'Select Item',
      mobile = 'null';
  int payper = 0, proper = 0;
  final formatter = new DateFormat('dd-MM-yyyy');

  final _storage = FirebaseStorage.instance;
  File _image;
  String uri, startDate, endDate;

  void loadData() async {
    var snap = await Firestore.instance
        .collection('Client')
        .document(widget.uid)
        .get();
    setState(() {
      if (snap != null) {
        overalldevstatus = (snap.data['overalldevstatus'] == null)
            ? 'Select Item'
            : snap.data['overalldevstatus'];
        uistatus = (snap.data['uistatus'] == null)
            ? 'Select Item'
            : snap.data['uistatus'];
        devstatus = (snap.data['devstatus'] == null)
            ? 'Select Item'
            : snap.data['devstatus'];
        payper = (snap.data['payper'] == null) ? 'null' : snap.data['payper'];
        proper = (snap.data['proper'] == null) ? 'null' : snap.data['proper'];
        mobile = (snap.data['mobile'] == null) ? 'null' : snap.data['mobile'];
        startDate = (snap.data['sd'] == null)
            ? '00-00-0000'
            : formatter
                .format(DateTime.fromMillisecondsSinceEpoch(snap.data['sd']));
        endDate = (snap.data['ed'] == null)
            ? '00-00-0000'
            : formatter
                .format(DateTime.fromMillisecondsSinceEpoch(snap.data['ed']));
      }
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future uploadPic() async {
    StorageReference reference = _storage
        .ref()
        .child(_image.path.substring(_image.path.lastIndexOf('/') + 1));
    StorageUploadTask uploadTask = reference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    uri = await reference.getDownloadURL();
  }

  void changeods(String val) {
    this.overalldevstatus = val;
  }

  void changeuip(String val) {
    this.uistatus = val;
  }

  void changedevp(String val) {
    this.devstatus = val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DataEditor'),
        leading: Icon(Icons.assignment),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              fireStore.collection('Client').document(widget.uid).updateData(
                {
                  'devstatus': devstatus,
                  'uistatus': uistatus,
                  'overalldevstatus': overalldevstatus,
                  'payper': payper,
                  'proper': proper
                },
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Start Date: $startDate', style: TextStyle(fontFamily: "Open Sans", fontSize: 16),),
                Text('End Date: $endDate', style: TextStyle(fontFamily: "Open Sans", fontSize: 16),),
              ],
            ),
            ListTile(
              title: TextField(
                controller: TextEditingController(text: payper.toString()),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  payper = int.parse(val);
                },
                decoration: InputDecoration(labelText: 'Payment Percentage'),
              ),
            ),
            ListTile(
              title: TextField(
                controller: TextEditingController(text: proper.toString()),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  proper = int.parse(val);
                },
                decoration: InputDecoration(labelText: 'Process Percentage'),
              ),
            ),
            ListTile(
              title: DButton(changeods, overalldevstatus),
              subtitle: Text('Overall development status'),
            ),
            ListTile(
              title: DButton(changeuip, uistatus),
              subtitle: Text('UI status'),
            ),
            ListTile(
              title: DButton(changedevp, devstatus),
              subtitle: Text('Development status'),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    await getImage();
                    await uploadPic();
                    fireStore
                        .collection('Client')
                        .document(widget.uid)
                        .updateData({
                      'uiimageuri': uri,
                    });
                  },
                  child: Text('Upload UI Image'),
                ),
                RaisedButton(
                  onPressed: () async {
                    await getImage();
                    await uploadPic();
                    fireStore
                        .collection('Client')
                        .document(widget.uid)
                        .updateData({
                      'devimageuri': uri,
                    });
                  },
                  child: Text('Upload Dev. Image'),
                ),
                RaisedButton(
                  onPressed: () async {
                    var snap = await Firestore.instance
                        .collection('Client')
                        .document(widget.uid)
                        .get();
                    if (snap != null) {
                      mobile = (snap.data['mobile'] == null)
                          ? 'null'
                          : snap.data['mobile'];
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
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Colors.redAccent,
              child: Text(
                'Click here if Project is completed',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                fireStore.collection('Client').document(widget.uid).updateData(
                  {
                    'devstatus': 'done',
                    'uistatus': 'done',
                    'overalldevstatus': 'done',
                    'payper': 100,
                    'proper': 100,
                    'ed':DateTime.now().millisecondsSinceEpoch,
                  },
                );
                fireStore
                    .collection('Client')
                    .document(widget.uid)
                    .collection('messages')
                    .add({
                  'text': 'Congrats Your Project is Succesfully Completed.',
                  'sender': 'Admin',
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DButton extends StatefulWidget {
  final func;
  final String value;
  DButton(this.func, this.value);
  @override
  _DButtonState createState() => _DButtonState();
}

class _DButtonState extends State<DButton> {
  String value;

  setValue(x) {
    setState(() {
      value = x;
    });
  }

  @override
  void initState() {
    setValue(widget.value);
    print(widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: value,
      isExpanded: true,
      items: [
        DropdownMenuItem(
          child: Text('Select Item'),
          value: 'Select Item',
        ),
        DropdownMenuItem(
          child: Text('Started'),
          value: 'started',
        ),
        DropdownMenuItem(
          child: Text('InProgress'),
          value: 'inprogress',
        ),
        DropdownMenuItem(
          child: Text('Done'),
          value: 'done',
        ),
      ],
      onChanged: (val) {
        widget.func(val);
        setState(() {
          value = val;
        });
      },
    );
  }
}
