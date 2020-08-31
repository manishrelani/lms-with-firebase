import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/InitialPage.dart';
import 'package:lms/admin/admin_home_screen.dart';
import 'package:lms/screen/ForgotScreen.dart';
import 'package:lms/screen/SignupPage.dart';
import 'package:lms/util/ShareManager.dart';
import 'package:lms/util/display_alert.dart';
import 'package:lms/util/firebase.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  FireBase firebase = FireBase();
  /* String phoneCode = "+91";
  String phone = "1234567890";
  String email = "hello@world.com"; */

  // static String validNumber = r'(^(?:[+0]9)?[0-9]{10}$)';
  static RegExp validEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var isHidden = true;
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        _body(size)
                      ],
                    ),
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
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.01),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  Image.asset("assets/images/admin.png"),
            _emailField(size),
            _passwordTextField(size),
            loginButton(size),
            _textDetails(
                first: "Forgot your login Details? ",
                sec: "Click here",
                route: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => ForgotScreen()));
                }),
            centerLine(),
            _textDetails(
                first: "Don't have Account? ",
                sec: "Signup",
                route: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => SignupPage()));
                }),
          ],
        ),
      ),
    );
  }

  Widget centerLine() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
                height: 1,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                )),
          ),
          Text("  OR  "),
          Expanded(
            child: Container(
                height: 1,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                )),
          ),
        ],
      ),
    );
  }

  Widget _emailField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
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
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextFormField(
        obscureText: isHidden,
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
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onTap: () {
                setState(() {
                  isHidden = !isHidden;
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
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
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

  Widget _textDetails({String first, String sec, Function route}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          first,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        GestureDetector(
          child: Text(
            sec,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w700),
          ),
          onTap: route,
        )
      ],
    );
  }

  login(context) {
    if (_formKey.currentState.validate()) {
      loadProgress();
      firebase
          .signIn(_emailController.text.trim(), _passController.text)
          .then((data) {
        loadProgress();
        if ("${data.runtimeType}" == "FirebaseUser") {
          FirebaseUser user = data;
          firebase.getUserData(user.uid).then((value) {
            ShareMananer.setDetails(value.data["name"], value.data["mobile"],
                value.data["email"], value.data["id"], true, "user", user.uid);
            Fluttertoast.showToast(msg: "Successfully loged in",textColor: Colors.black);
            Timer(Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (ctx) => AdminHomeScreen()),
                  (route) => false);
            });
          });
        } else {
          Fluttertoast.showToast(msg: data.toString(),textColor: Colors.black);
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
