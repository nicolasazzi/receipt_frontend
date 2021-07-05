import 'package:flutter/material.dart';
import 'package:receipt/login.dart';
import 'template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'to_excel.dart';

Widget profileBuilder(BuildContext context) {

  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'First name: ${globals.prefs.getString('first_name')}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Last name: ${globals.prefs.getString('last_name')}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Phone number: ${globals.prefs.getString('phone_number')}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 250,
              ),
              ElevatedButton(
                onPressed: () {
                  createExcel();
                },
                child: Text(
                  'Export data to excel',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.grey,
                ),
                onPressed: () {
                  logout(context);
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void logout(BuildContext context) async{
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');

  Route route = MaterialPageRoute(builder: (context) => LoginPage());
  Navigator.pushReplacement(context, route);
}
