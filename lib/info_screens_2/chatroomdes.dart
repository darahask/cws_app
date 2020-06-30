import 'package:cws_app/adminsprivate/admin_select.dart';
import 'package:cws_app/employee_status.dart';
import 'package:cws_app/supportclasses/supportchat.dart';
import "package:flutter/material.dart";

class DesChatRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Client Support Manager'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => SupportChat(type:'Design Admin')));
                },
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => SupportChat(type:'Design Admin')));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Design Employees'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) =>
                              EmployeeStatus(type: 'Design Admin')));
                },
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            EmployeeStatus(type: 'Design Admin')));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Prithvi Sir'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) =>
                              AdminChatSelect('Design Admin')));
                },
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            AdminChatSelect('Design Admin')));
              },
            ),
          ),
        ],
      ),
    );
  }
}
