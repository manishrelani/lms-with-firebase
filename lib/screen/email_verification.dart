import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/admin/admin_home_screen.dart';
import 'package:lms/util/firebase.dart';

class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final firebase = FireBase();
  @override
  void initState() {
    firebase.sendEmailVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFeaeaea),
      appBar: AppBar(
        title: Text("Email verification",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFFeaeaea),
      ),
      body: Container(
        margin: EdgeInsets.all(25), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please Verify your email address",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            button(size)
          ],
        ),
      ),
    );
  }

  Widget button(Size size) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.lightBlue,
        ),
        margin: EdgeInsets.symmetric(vertical: size.height * 0.05),
        child: MaterialButton(
            shape: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8)),
            color: Colors.black12,
            height: 50,
            minWidth: double.infinity,
            child: Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              firebase.isEmailVerified().then((value) {
                if (value) {
                  Fluttertoast.showToast(msg: "Welcome",textColor: Colors.black);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => AdminHomeScreen()));
                } else {
                  Fluttertoast.showToast(msg: "Please Verify your Email",textColor: Colors.black);
                }
              });
            }),
      ),
    );
  }
}
