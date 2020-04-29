import 'package:cws_app/supportclasses/support_client.dart';
import 'package:cws_app/supportclasses/support_devmanager.dart';
import 'package:flutter/material.dart';

class SupportSwitch extends StatefulWidget {
  final String type;
  SupportSwitch({this.type});

  @override
  _SupportSwitchState createState() => _SupportSwitchState();
}

class _SupportSwitchState extends State<SupportSwitch> {
  int num = 0;

  // final widgets1 = [
  //   EmployeeDashboard('Sales Employee'),
  //   EmployeeChat('Sales Employee'),
  //   SalesRegister()
  // ];
  // final items_b1 = [
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.dashboard,
  //     ),
  //     title: Text(
  //       'Dashboard',
  //     ),
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.message,
  //     ),
  //     title: Text('Chat'),
  //   ),
  //   BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.account_circle,
  //     ),
  //     title: Text('Register'),
  //   ),
  // ];

  List<Widget> widgets = [];
  List<BottomNavigationBarItem> items_b = [];

  loadData(String type) {
    widgets = [SupportClient(), SupportDev()];
    items_b = [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.people,
        ),
        title: Text(
          'Clients',
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.people,
        ),
        title: Text('Dev Managers'),
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
        body: widgets[num], //(widget.type == 'Sales Employee') ? widgets1[num] : widgets[num],
        bottomNavigationBar: BottomNavigationBar(
          items: items_b,//(widget.type == 'Sales Employee') ? items_b1 : items_b,
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