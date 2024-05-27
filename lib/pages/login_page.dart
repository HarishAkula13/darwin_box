
import 'dart:convert';

import 'package:darwin_box/di/i_login_page.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Utils/constant.dart';
import '../app/arch/bloc_provider.dart';
import '../bloc/login_bloc.dart';
import '../di/app_injector.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginBloc? _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }


  Future<void> login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    var sharedPref = EncryptedSharedPreferences.getInstance();


    final storedUser= sharedPref.getString(Constants.LOGIN)!=null?json.decode(sharedPref.getString(Constants.LOGIN) ?? '{}'):null;


    if (storedUser == null) {
      showMessage('User registered and logged in',1);
      sharedPref.setString(Constants.LOGIN, json.encode({'username':username,'password':password}),notify: true);
    } else if (storedUser['username'] == username && storedUser['password'] == password) {
      Get.to(AppInjector.instance.weatherPage);

    }  else if(username.isEmpty&&password.isEmpty){
      showMessage('Enter username and Password',0);
    }else if(username.isEmpty){
      showMessage('Enter username',0);
    } else if(password.isEmpty){
      showMessage('Enter Password',0);
    }
    else{
      showMessage('Invalid username or password',0);
    }
  }

  void showMessage(String message,int type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if(type==1){
                Get.to(AppInjector.instance.weatherPage);
              }
              Navigator.of(context).pop();},
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(alignment: Alignment.centerLeft,
                child: Text('UserName')),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5),

              decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 1),borderRadius: BorderRadius.all(Radius.circular(5)),),
              child: TextField(
                enableSuggestions: false,
                autocorrect: false,
                controller: _usernameController,
                decoration: InputDecoration(border: InputBorder.none,hintText: "UserName",hintStyle: TextStyle(fontSize: 12)),
                style: TextStyle(decoration: TextDecoration.none,),
              ),
            ),
            SizedBox(height: 15,),
            Align(alignment: Alignment.centerLeft,
                child: Text('Password')),
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey,width: 1)),
              child: TextField(
                controller: _passwordController,

                decoration: InputDecoration(border: InputBorder.none,hintText: "Password",hintStyle: TextStyle(fontSize: 12)),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 40,width: 100,
              child: ElevatedButton(
                  onPressed: login,
                  child: Text('Login',style: TextStyle(color: Colors.white),),

                  style: ElevatedButton.styleFrom( shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                      backgroundColor: Colors.black,
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold)
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
