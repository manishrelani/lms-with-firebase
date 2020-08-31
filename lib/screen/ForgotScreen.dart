import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/util/firebase.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final forgotController = TextEditingController();

  static String validEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  RegExp regEmail = new RegExp(validEmail);
  final TextEditingController _emailController = TextEditingController();

  bool isClear = false;
  bool isEmail = false;
  FireBase firebase = FireBase();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.topLeft,
                child: logo(),
              ),
              _emailField(size),
              loginButton(size),
              //   Mybutton(title: "Send", function: isEmail ? forgot : null),
            ],
          ),
        ),
      ),
    );
  }

  logo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Text(
          "Forgot Password?",
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Enter your email address here",
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  Widget _emailField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextField(
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
      ),
    );
  }

  void changeFunction() {
    if (regEmail.hasMatch(forgotController.text)) {
      isEmail = true;
    } else {
      isEmail = false;
    }
    if (forgotController.text.isNotEmpty) {
      isClear = true;
    } else {
      isClear = false;
    }
    setState(() {});
  }

  Widget loginButton(Size size) {
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
          "Send Code",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          firebase.resetPassword(_emailController.text.trim());
          Fluttertoast.showToast(
              msg: "Link Has been sent to your email address",
              textColor: Colors.black);
          Navigator.pop(context);
        },
      ),
    );
  }
}
