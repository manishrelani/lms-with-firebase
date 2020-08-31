import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/admin/admin_home_screen.dart';
import 'package:lms/screen/OtpPage.dart';
import 'package:lms/screen/email_verification.dart';
import 'package:lms/util/ShareManager.dart';
import 'package:lms/util/display_alert.dart';
import 'package:lms/util/firebase.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  FireBase firebase = FireBase();

  bool _isHidden = true;
  bool isPass = false;
  String selectedName = "";
  var member = false;
  var isLoading = false;

  static String validNumber = r'(^(?:[+0]9)?[0-9]{10}$)';
  static String validEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  RegExp regValidNumber = new RegExp(validNumber);
  RegExp regEmail = new RegExp(validEmail);

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userIdController = TextEditingController();

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
                        _body(context, size)
                      ],
                    ),
                  )
                : _body(context, size)),
        isLoading ? showProgress(context) : Container()
      ],
    );
  }

  Widget _body(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _titleText(),
              _subtitle(),
              _textFormField(
                size: size,
                hintText: "Name",
                controller: _nameController,
                icon: Icons.person,
                type: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
                    return "Please Enter Your Name";
                  }
                  return null;
                },
              ),
              _textFormField(
                size: size,
                controller: _emailController,
                hintText: "Email ID",
                icon: Icons.email,
                type: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
                    return "Please Enter Email id";
                  } else if (!regEmail.hasMatch(value.trim())) {
                    return "Please Enter Valid Email id";
                  }
                  return null;
                },
              ),
              _textFormField(
                size: size,
                controller: _numberController,
                hintText: "Mobile no",
                icon: Icons.phone_android,
                type: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please Enter Your Mobile no";
                  } else if (!regValidNumber.hasMatch(value.toString())) {
                    return "Please Enter Valid Mobile no";
                  }
                  return null;
                },
              ),
              _passTextField(size),
              _askUniversity(size),
              Visibility(
                  visible: member,
                  child: _textFormField(
                    size: size,
                    controller: _userIdController,
                    hintText: "User ID",
                    icon: Icons.assignment_ind,
                    type: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Your College id";
                      }
                      return null;
                    },
                  )),
              signInButton(size),
            ],
          ),
        ),
      ),
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

  Widget _titleText() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "Signup",
        style: Theme.of(context)
            .textTheme
            .headline4
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _subtitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "Welcome aboard! Please Enter All Details to Complate Process",
        //  textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.caption.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _passTextField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _isHidden,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
          ),
          suffixIcon: GestureDetector(
            child: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
            onTap: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
          ),
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
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Please Enter Password";
          } else if (value.length < 6) {
            return "password should be at least 6 characters long";
          }
          return null;
        },
      ),
    );
  }

  Widget _askUniversity(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Are you a Member of Oxford brooks University?",
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: true,
                groupValue: member,
                onChanged: (value) {
                  setState(() {
                    member = value;
                  });
                },
              ),
              Text(
                'Yes',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 16),
              ),
              Radio(
                value: false,
                groupValue: member,
                onChanged: (value) {
                  setState(() {
                    member = value;
                  });
                },
              ),
              Text(
                'No',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _textFormField(
      {TextEditingController controller,
      Size size,
      String hintText,
      IconData icon,
      TextInputType type,
      String validator(String)}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: TextFormField(
            controller: controller,
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 16.0,
                ),
            keyboardType: type,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            validator: validator));
  }

  Widget signInButton(Size size) {
    return Builder(
      builder: (context) => Container(
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
              "Signup",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                signup(context);
              }
            }),
      ),
    );
  }

  signup(context) {
    if (member) {
      loadProgress();
      firebase.clgStaff(_userIdController.text.trim()).then((value) {
        loadProgress();
        if (value) {
          print("valid");
          process();
        } else {
          print("not");
          Fluttertoast.showToast(
              msg: "Please Enter Valid ID", textColor: Colors.black);
        }
      });
    } else {
      process();
    }
  }

  process() {
    loadProgress();
    firebase
        .signUp(_emailController.text.trim(), _passwordController.text)
        .then((value) {
      if ("${value.runtimeType}" == "FirebaseUser") {
        FirebaseUser firebaseUser = value;
        if (firebaseUser != null) {
          Map<String, String> data = Map();
          data['name'] = _nameController.text.trim();
          data['email'] = _emailController.text.trim();
          data['mobile'] = _numberController.text.trim();
          data['id'] = _userIdController.text.trim();

          firebase.addUserData(data, firebaseUser).then((value) {
            loadProgress();
            ShareMananer.setDetails(
                _nameController.text.trim(),
                _numberController.text.trim(),
                _emailController.text.trim(),
                _userIdController.text.trim(),
                true,
                "user",
                firebaseUser.uid);
            Timer(Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (ctx) => EmailVerification()),
                  (route) => false);
            });
          });
        }
      } else {
        Fluttertoast.showToast(msg: value.toString(), textColor: Colors.black);
      }
    });
  }

  loadProgress() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
