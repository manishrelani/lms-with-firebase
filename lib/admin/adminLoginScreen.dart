import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/admin/admin_home_screen.dart';
import 'package:lms/util/ShareManager.dart';
import 'package:lms/util/display_alert.dart';
import 'package:lms/util/firebase.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  FireBase firebase = FireBase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  static RegExp validEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  var isHide = true;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
            appBar: _appbar(),
            body: MediaQuery.of(context).size.width > 800
                ? SingleChildScrollView(
                    child: _body(size),
                  )
                : _body(size)),
        isLoading ? showProgress(context) : Container()
      ],
    );
  }

  Widget _appbar() {
    return AppBar(
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _body(Size size) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/admin.png"),
          _emailField(size),
          _passwordTextField(size),
          loginButton(size)
        ],
      ),
    );
  }

  Widget _emailField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.01),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: "Email id",
          hintStyle: TextStyle(color: Colors.grey),
        ),
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Please Enter Email Address";
          } else if (!validEmail.hasMatch(value.trim())) {
            return "Please Enter Valid Email Address";
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordTextField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.01),
      child: TextFormField(
        obscureText: isHide,
        controller: _passController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.grey),
            suffix: GestureDetector(
              child: Icon(
                isHide ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onTap: () {
                setState(() {
                  isHide = !isHide;
                });
              },
            )),
        validator: (value) {
          if (value.isEmpty || value.trim().isEmpty) {
            return "Please Enter password";
          }
          return null;
        },
      ),
    );
  }

  Widget loginButton(Size size) {
    return Builder(builder: (context) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.lightBlue,
        ),
        margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.01),
        child: MaterialButton(
            shape: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8)),
            color: Colors.black12,
            height: 50,
            minWidth: double.infinity,
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              login(context);
            }),
      );
    });
  }

  login(context) {
    if (_formKey.currentState.validate()) {
      loadProgress();
      firebase
          .signIn(_emailController.text.trim(), _passController.text)
          .then((value) {
        loadProgress();
        if ("${value.runtimeType}" == "FirebaseUser") {
          FirebaseUser user = value;
          if (user.uid != "eEK6KzeefFR4CIZ9HVrHlsdDyUl1") {
            loadProgress();
            Fluttertoast.showToast(msg: "User does not Authorized",textColor: Colors.black);
            firebase.signOut().then((value) => loadProgress());
          } else {
            firebase.getUserData(user.uid).then((value) {
              ShareMananer.setDetails(
                  value.data["name"],
                  value.data["mobile"],
                  value.data["email"],
                  value.data["id"],
                  true,
                  "admin",
                  user.uid);
              Fluttertoast.showToast(msg: "Successfully loged in",textColor: Colors.black);
              Timer(Duration(seconds: 1), () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (ctx) => AdminHomeScreen()),
                    (route) => false);
              });
            });
          }
        } else {
          print(value);
          Fluttertoast.showToast(msg: value.toString(),textColor: Colors.black);
        }
      });
    }
  }

  loadProgress() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
