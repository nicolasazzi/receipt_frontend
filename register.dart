
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:receipt/template.dart';
import 'dart:convert';
import 'dart:async';
import 'globals.dart' as globals;
import 'receipt.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _phoneNumber, _firstName, _lastName, _password, _repeatPassword;
  bool _phoneValid;
  bool _errorRegistration;
  final _formKey = GlobalKey<FormState>();

  Future<void> reg(String phone, BuildContext context) async {

    var response = await http.post(Uri.parse('https://nicolasazzi.pythonanywhere.com/account/check/'), body: {'phone':phone});
    var j = json.decode(response.body);

    _phoneValid = j['allowed'];

    if(!_formKey.currentState.validate()){
      return;
    }

    var registerData = {
      "first_name": _firstName,
      "last_name": _lastName,
      "phone_number": _phoneNumber,
      "password": _password,
    };
    var registerResponse = await http.post(Uri.parse('https://nicolasazzi.pythonanywhere.com/account/register/'), body: registerData);

    if (registerResponse.statusCode == 200){
      var registerJson = json.decode(registerResponse.body);

      globals.prefs.setString('token', registerJson['token']);

      await fetchReceipts();

      Route route = MaterialPageRoute(builder: (context) => Template());
      Navigator.pushReplacement(context, route);
    }

  }

  Widget _buildPhoneNumber(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Phone Number',
      ),
      validator: (value) {
        String feedback = "";

        if (value.isEmpty){
          feedback += "This field is required.\n";
        }
        if (value.length>8){
          feedback += "Phone number must be 8 or less digits.\n";
        }
        if (!_phoneValid){
          feedback += "Phone number already in use.\n";
        }
        try {
          int.parse(value);
        }
        catch (e){
          feedback += "Must be valid phone number.\n";
        }
        if (feedback == "") {
          return null;
        }
        else{
          return feedback.substring(0,feedback.length-2);
        }
      },
      onSaved: (String value){
        _phoneNumber = value;
      },
    );
  }

  Widget _buildFirstName(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'First Name',
      ),
      validator: (value) {
        if (value.isEmpty){
          return "This field is required.";
        }
        return null;
      },
      onSaved: (String value){
        _firstName = value;
      },
    );
  }

  Widget _buildLastName(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Last Name',
      ),
      validator: (value) {
        if (value.isEmpty){
          return "This field is required.";
        }
        return null;
      },
      onSaved: (String value){
        _lastName = value;
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
        return null;
      },
      onSaved: (String value){
        _password = value;
      },
      obscureText: true,
    );
  }

  Widget _buildRepeatPassword(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Repeat Password',
      ),
      validator: (value) {
        if (value.isEmpty){
          return "This field is required.";
        }
        else if (_password != value){
          return "Passwords does not match.";
        }
        return null;
      },
      onSaved: (String value){
        _repeatPassword = value;
      },
      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext mainContext) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              'Register',
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
                    _buildFirstName(),
                    _buildLastName(),
                    _buildPassword(),
                    _buildRepeatPassword(),
                    SizedBox(height: 20,),
                    ElevatedButton(
                        onPressed: () {
                          _formKey.currentState.save();
                          reg(_phoneNumber, context);
                        },
                        child: Text('Register'),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(mainContext);
                      },
                      child: Text('Back'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
