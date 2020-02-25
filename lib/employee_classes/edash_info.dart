import 'package:flutter/material.dart';

class EmployeeDashboard extends StatefulWidget {

  EmployeeDashboard(this.type);
  final String type;

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "DASHBOARD",
                style: TextStyle(
                  color: Color(0xff034198),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  letterSpacing: .7,
                  shadows: kElevationToShadow[4],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'FutureWork: ',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, letterSpacing: .6),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'PresentWork: ',
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, letterSpacing: .6),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Salary: (In Rupees)',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '2000',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff034198),
                        letterSpacing: 1
                      ),
                    ),

                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 4,
        child: Icon(
          Icons.assignment_turned_in,
        ),
      ),
    );
  }
}
