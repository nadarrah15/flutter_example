import 'package:flutter/material.dart';
import 'package:flutter_example/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

final GlobalKey<FormFieldState<String>> _password = new GlobalKey<FormFieldState<String>>();
final GlobalKey<FormFieldState<String>> _user = new GlobalKey<FormFieldState<String>>();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final title = Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'Mund Dining Hall',
        style: TextStyle(fontSize: 28.0, color: Colors.yellow),
      ),
    );

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/whitelvc_logo.png'),

      )
    );

    final email = TextFormField(
      key: _user,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: 'someone@gmail.com',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      key: _password,
      autofocus: false,
      initialValue: 'some password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () => checkResponse(_user.currentState.value, _password.currentState.value).then((bool b) {
            if(b)
              Navigator.of(context).pushNamed(HomePage.tag);
          }),

          color: Colors.yellow,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );



    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            title,
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );

  }
}


Future<bool> checkResponse(String user, String pass) async{

  Map jsonData = {
    "user" : _user.currentState.value,
    "password" : _password.currentState.value
  };

  HttpClientRequest request =
    await new HttpClient().post("10.1.21.229", 6666, "")
      ..headers.contentType = ContentType.JSON
      ..write(jsonEncode(jsonData));

  HttpClientResponse response = await request.close();
  await response.transform(utf8.decoder /*5*/).forEach(print);
  print(response.statusCode);
    if(response.statusCode == 200)
      return true;
    else
      return false;
}

