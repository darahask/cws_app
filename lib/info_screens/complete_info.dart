import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompleteInfo extends StatefulWidget {
  @override
  _CompleteInfoState createState() => _CompleteInfoState();
}

class _CompleteInfoState extends State<CompleteInfo> {
  var list = [];

  void loadData() async {
    var x = await Firestore.instance.collection('Client').getDocuments();
    setState(
      () {
        for (var doc in x.documents) {
          if (doc.data['overalldevstatus'] == 'done') {
            list.insert(0, doc);
          }
        }
      },
    );
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 45,
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
                'Total Completed Projects: ${list.length} ',
                style: TextStyle(color: Colors.white, fontSize: 22,fontFamily: 'OpenSans',fontWeight: FontWeight.bold,),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              return CompleteContainer(
                  list[i].data['name'], list[i].data['overalldevstatus']);
            },
          ),
        ),
      ],
    ));
  }
}

class CompleteContainer extends StatelessWidget {
  final String name, doc;
  CompleteContainer(this.name, this.doc);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: kElevationToShadow[4],
            borderRadius: BorderRadius.circular(10),
            
          ),
          child: ListTile(
            leading: Image.asset(
              'images/darklogo.png',
              fit: BoxFit.cover,
            ),
            title: Text(
              name,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans'),
            ),
            subtitle: Text(doc),
          ),
        ));
  }
}
