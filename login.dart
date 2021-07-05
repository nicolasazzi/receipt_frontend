
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receipt/receipt.dart';
import 'package:receipt/template.dart';
import 'package:receipt/register.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  BuildContext loginContext;

  @override
  void initState(){
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    globals.prefs = await SharedPreferences.getInstance();
    if (globals.prefs.containsKey('token')){
      await fetchReceipts();

      Route route = MaterialPageRoute(builder: (context) => Template());
      Navigator.pushReplacement(loginContext, route);
    }
  }

  String _phoneNumber, _password;
  bool _credentialsValid;
  final _formKey = GlobalKey<FormState>();

  Future<void> log(String phone, String password, BuildContext context) async {
    var loginData = {
      "phone_number": _phoneNumber,
      "password": _password,
    };
    var response = await http.post(Uri.parse('https://nicolasazzi.pythonanywhere.com/account/login/'), body: loginData);
    var j = json.decode(response.body);

    if (response.statusCode == 200) {
      _credentialsValid = true;
    }
    else {
      _credentialsValid = false;
    }

    if(!_formKey.currentState.validate()){
      return;
    }

    globals.prefs.setString('token', j['token']);
    globals.prefs.setString('first_name', j['first_name']);
    globals.prefs.setString('last_name', j['last_name']);
    globals.prefs.setString('phone_number', j['phone_number']);

    await fetchReceipts();

    Route route = MaterialPageRoute(builder: (context) => Template());
    Navigator.pushReplacement(loginContext, route);
  }


  Widget _buildPhoneNumber(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
      ),
      validator: (value) {

        if (value.isEmpty){
          return "This field is required.";
        }
        else if (!_credentialsValid){
          return "Wrong credentials";
        }
        return null;
      },
      onSaved: (String value){
        _phoneNumber = value;
      },
    );
  }


  Widget _buildPassword(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      validator: (value) {
        if (value.isEmpty){
          return "This field is required.";
        }
        else if (!_credentialsValid){
          return "Wrong credentials";
        }
        return null;
      },
      onSaved: (String value){
        _password = value;
      },
      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {

          loginContext = context;

          return Scaffold(
          appBar: AppBar(
            title: Text(
              'Login',
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPhoneNumber(),
                    _buildPassword(),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState.save();
                        log(_phoneNumber, _password, context);
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(builder: (context) => RegisterPage());
                        Navigator.push(context, route);
                      },
                      child: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        }
      ),
    );
  }
}
