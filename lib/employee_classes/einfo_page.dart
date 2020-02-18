import 'package:cws_app/employee_chat.dart';
import 'package:cws_app/employee_classes/edash_info.dart';
import 'package:cws_app/employee_classes/sales_registration.dart';
import 'package:cws_app/info_screens/feed_info.dart';
import 'package:cws_app/info_screens/employee_info.dart';
import 'package:flutter/material.dart';

class EmployeeInfoPage extends StatefulWidget {

  final String type;
  EmployeeInfoPage(this.type);

  @override
  _EmployeeInfoPageState createState() => _EmployeeInfoPageState();
}

class _EmployeeInfoPageState extends State<EmployeeInfoPage> {

  int num = 0;
  final widgets = [ EmployeeDashboard(),EmployeeChat()];
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
        Icons.message,
      ),
      title: Text(
        'Chat'
      ),
    )
  ];
  final widgets1 = [ EmployeeDashboard(),EmployeeChat(),SalesRegister()];
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
        Icons.message,
      ),
      title: Text(
          'Chat'
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.account_circle,
      ),
      title: Text(
          'Register'
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (widget.type == 'sales')?widgets1[num]:widgets[num],
        bottomNavigationBar: BottomNavigationBar(
          items: (widget.type == 'sales')?items_b1:items_b,
          onTap: (a) {
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
