import 'package:cws_app/employee_chat.dart';
import 'package:cws_app/employee_classes/edash_info.dart';
import 'package:cws_app/employee_classes/sales_registration.dart';
import 'package:flutter/material.dart';

class EmployeeInfoPage extends StatefulWidget {
  final String type;
  EmployeeInfoPage(this.type);

  @override
  _EmployeeInfoPageState createState() => _EmployeeInfoPageState();
}

class _EmployeeInfoPageState extends State<EmployeeInfoPage> {
  int num = 0;

  final widgets1 = [
    EmployeeDashboard('Sales Employee'),
    EmployeeChat('Sales Employee'),
    SalesRegister()
  ];
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
      title: Text('Chat'),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.account_circle,
      ),
      title: Text('Register'),
    ),
  ];

  List<Widget> widgets = [];
  List<BottomNavigationBarItem> items_b = [];

  loadData(String type) {
    widgets = [EmployeeDashboard(type), EmployeeChat(type)];
    items_b = [
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
        title: Text('Chat'),
      )
    ];
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    loadData(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (widget.type == 'Sales Employee') ? widgets1[num] : widgets[num],
        bottomNavigationBar: BottomNavigationBar(
          items: (widget.type == 'Sales Employee') ? items_b1 : items_b,
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
