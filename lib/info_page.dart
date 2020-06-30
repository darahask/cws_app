import 'package:cws_app/adminsprivate/admin_select.dart';
import 'package:cws_app/employee_status.dart';
import 'package:cws_app/info_screens/dash_info.dart';
import 'package:cws_app/info_screens/messags_info.dart';
import 'package:cws_app/info_screens/register_screen.dart';
import 'package:cws_app/info_screens/status_info.dart';
import 'package:cws_app/info_screens_2/chatroomdes.dart';
import 'package:cws_app/info_screens_2/chatroomdev.dart';
import 'package:cws_app/supportclasses/supportchat.dart';
import 'package:flutter/material.dart';

class InfoMain extends StatefulWidget {

  final String type;
  const InfoMain({this.type});

  @override
  _InfoMainState createState() => _InfoMainState();
}

class _InfoMainState extends State<InfoMain> {

  int num = 0;
  final widgets = [DashInfo('overall'),StatusInfo(),MessagesInfo(),EmployeeStatus(),AdminChatSelect('overall'),RegisterPage(),];
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
        Icons.person_outline,
      ),
      title: Text(
        'Managers',
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
  ];

  final widgets1 = [DashInfo('development'),StatusInfo(),DevChatRoom()];
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
  ];

  final widgets2 = [DashInfo('design'),StatusInfo(),MessagesInfo(),DesChatRoom()];
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
        'Chat',
      ),
    ),
  ];

  getData(String type) {
    if(type == 'overall'){
      return widgets;
    }else if(type == 'development'){
      return widgets1;
    }else{
      return widgets2;
    }
  }

  getItems(String type) {
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
