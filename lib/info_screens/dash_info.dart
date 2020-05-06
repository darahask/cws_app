import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashInfo extends StatefulWidget {
  final String type;
  DashInfo(this.type);
  @override
  _DashInfoState createState() => _DashInfoState();
}

class _DashInfoState extends State<DashInfo> {
  var list = [];
  int number = 0;

  void loadData() async {
    var x = await Firestore.instance.collection('Client').getDocuments();
    for (var doc in x.documents) {
      if (doc.data['overalldevstatus'] == 'done') {
        list.insert(0, doc);
      }
    }
    setState(() {
      
    });

    var d =
        await Firestore.instance.collection('Design Employee').getDocuments();
    var dev = await Firestore.instance
        .collection('Development Employee')
        .getDocuments();
    var s =
        await Firestore.instance.collection('Sales Employee').getDocuments();
    
    for (var doc in d.documents) {
      if ((DateTime.now().microsecondsSinceEpoch -
              int.parse(doc.data['presentworkstatus'])) <=
          86400000) {
        number++;
      }
    }
    
    for (var doc in dev.documents) {
      if ((DateTime.now().microsecondsSinceEpoch -
              int.parse(doc.data['presentworkstatus'])) <=
          86400000) {
        number++;
      }
    }
    
    for (var doc in s.documents) {
      if ((DateTime.now().microsecondsSinceEpoch -
              int.parse(doc.data['presentworkstatus'])) <=
          86400000) {
        number++;
      }
    }
    setState(() {
      
    });
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
        Text(
          'DASHBOARD',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 32,
            color: Color(0xff034198),
            fontWeight: FontWeight.w900,
            shadows: kElevationToShadow[2],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:10.0),
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
                "Today's Submissions: $number",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
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
      ),
    );
  }
}

// final _auth = FirebaseAuth.instance;
// final firestore = Firestore.instance;
// String type;

// void getType() async {
//   try {
//     var user = await _auth.currentUser();
//     var data = await firestore.collection('Over all Admin').getDocuments();
//     var data2 = await firestore.collection('Design Admin').getDocuments();
//     var data3 =
//         await firestore.collection('Development Admin').getDocuments();
//     for (var doc in data.documents) {
//       print(doc.documentID);
//       if (doc.documentID == user.uid) {
//         print(doc.documentID);
//         setState(() {
//           type = 'overall';
//         });
//       }
//     }
//     for (var doc in data2.documents) {
//       if (doc.documentID == user.uid) {
//         setState(() {
//           type = 'design';
//         });
//       }
//     }
//     for (var doc in data3.documents) {
//       if (doc.documentID == user.uid) {
//         setState(() {
//           type = 'development';
//         });
//       }
//     }
//   } catch (e) {
//     print(e);
//   }
// }

// @override
// void initState() {
//   getType();
//   super.initState();
// }

// @override
// Widget build(BuildContext context) {
//   return SafeArea(
//     child: Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: Text(
//                 'DASHBOARD',
//                 style: TextStyle(
//                   color: Color(0xff034198),
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.5,
//                   shadows: kElevationToShadow[4],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Container(
//                 height: 45,
//                 decoration: BoxDecoration(
//                   boxShadow: kElevationToShadow[8],
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(10),
//                   ),
//                   gradient: LinearGradient(
//                     colors: [Color(0xff09a5e0), Color(0xff034198)],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Total Completed Projects: ',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontFamily: 'OpenSans',
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 height: 90,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(10),
//                   ),
//                   boxShadow: kElevationToShadow[8],
//                   gradient: LinearGradient(
//                     colors: [Color(0xff09a5e0), Color(0xff034198)],
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Total Employee completed their task today',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
