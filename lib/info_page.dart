import 'package:cws_app/employee_status.dart';
import 'package:cws_app/info_screens/complete_info.dart';
import 'package:cws_app/info_screens/dash_info.dart';
import 'package:cws_app/info_screens/messags_info.dart';
import 'package:cws_app/info_screens/register_screen.dart';
import 'package:cws_app/info_screens/status_info.dart';
import 'package:cws_app/supportclasses/supportchat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseUser loggedInUser;

class InfoMain extends StatefulWidget {

  final String type;
  const InfoMain({this.type});

  @override
  _InfoMainState createState() => _InfoMainState();
}

class _InfoMainState extends State<InfoMain> {

  int num = 0;
  final widgets = [DashInfo(),StatusInfo(),MessagesInfo(),EmployeeStatus(),RegisterPage(),CompleteInfo(),];
  final items_b = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.dashboard,
      ),
      title: Text(
        'Dashboard',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.computer,
      ),
      title: Text(
        'Status',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.message,
      ),
      title: Text(
        'Messages',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.people,
      ),
      title: Text(
        'Employees',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.account_circle,
      ),
      title: Text(
        'Register',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.assignment_turned_in,
      ),
      title: Text(
        'Completed',
      ),
    ),
  ];

  final widgets1 = [DashInfo(),StatusInfo(),SupportChat(),EmployeeStatus(),CompleteInfo(),];
  final items_b1 = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.dashboard,
      ),
      title: Text(
        'Dashboard',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.computer,
      ),
      title: Text(
        'Status',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.message,
      ),
      title: Text(
        'Messages',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.people,
      ),
      title: Text(
        'Employees',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.assignment_turned_in,
      ),
      title: Text(
        'Completed',
      ),
    ),
  ];

  final widgets2 = [DashInfo(),StatusInfo(),MessagesInfo(),EmployeeStatus(),CompleteInfo(),];
  final items_b2 = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.dashboard,
      ),
      title: Text(
        'Dashboard',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.computer,
      ),
      title: Text(
        'Status',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.message,
      ),
      title: Text(
        'Messages',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.people,
      ),
      title: Text(
        'Employees',
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.assignment_turned_in,
      ),
      title: Text(
        'Completed',
      ),
    ),
  ];

  void getCurrentUser() async{
    try {
      var user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    loadData();
    super.initState();
  }

  loadData(){
    
  }

  getData(String type){
    if(type == 'overall'){
      return widgets;
    }else if(type == 'development'){
      return widgets1;
    }else{
      return widgets2;
    }
  }

  getItems(String type){
    if(type == 'overall'){
      return items_b;
    }else if(type == 'development'){
      return items_b1;
    }else{
      return items_b2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: getData(widget.type)[num],
        bottomNavigationBar: BottomNavigationBar(
          items: getItems(widget.type),
          onTap: (a){
            setState(() {
              num = a;
            });
          },
          unselectedItemColor: Colors.black.withAlpha(150),
          currentIndex: num,
          selectedItemColor: Color(0xff09a5e0),
          showSelectedLabels: true,

        ),
      ),
    );
  }
}
