import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/screen/email_verification.dart';
import 'package:lms/util/firebase.dart';

class OtpPage extends StatefulWidget {
  final moNumber;
  OtpPage({this.moNumber});
  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  var resentOTP = "";
  // var otpSuccess = false;
  String verificationId;
  FireBase fireBase = FireBase();
  FirebaseUser user;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int count;

  TextEditingController otpController = new TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    verifyPhone();
    startTimer();
    super.initState();
  }

  Future<void> verifyPhone() async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      print(
          'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded:');
      AuthResult result = fireBase.signInOtp(authResult);
      setState(() {
        user = result.user;
      });
      if (user != null) {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
        Fluttertoast.showToast(msg: "verified",textColor: Colors.black);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => EmailVerification()));
      } else {
        print("error");
      }
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      Fluttertoast.showToast(msg: authException.message,textColor: Colors.black);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      setState(() {
        this.verificationId = verId;
        AuthResult result =
            fireBase.signInWithOTP(otpController.text.trim(), verificationId);
        user = result.user;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91 ${widget.moNumber}",
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Timer timer;

  void startTimer() {
    count = 60;
    timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (count < 1) {
            timer.cancel();
          } else {
            count = count - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text("Verification",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFFeaeaea), 
      ),
      backgroundColor: Color(0xFFeaeaea),
      body: Container(
        padding: EdgeInsets.all(25),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            otpBox(size),
            button(size)
          ],
        ),
      ),
    );
  }

  Widget otpBox(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4.0, right: 16.0),
          child: resentOTP == ""
              ? Text(
                  "We have sent 6 digit code on",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                )
              : Text(
                  resentOTP,
                  style: Theme.of(context).textTheme.headline5,
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 5.0, right: 30.0),
          child: Text(
            "+91 ${widget.moNumber}",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _otpField(size),
        Text("Didn't you received any code?"),
        count == 0
            ? FlatButton(
                onPressed: () {
                  setState(() {
                    verifyPhone();
                    startTimer();
                    resentOTP = "OTP has been resent on";
                  });
                },
                child: Text(
                  "Resent OTP",
                  style: TextStyle(
                    // color: AppTheme.primaryColor,
                    fontSize: 16.0,
                  ),
                ))
            : Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Resend otp in $count secs",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                  ),
                ),
              ),
      ],
    );
  }

  Widget button(Size size) {
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
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (user != null) {
                Fluttertoast.showToast(msg: "verified",textColor: Colors.black);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => EmailVerification()));
              } else {
                Fluttertoast.showToast(msg: "Please check otp",textColor: Colors.black);
              }
            }),
      ),
    );
  }

  Widget _otpField(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextFormField(
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 20),
        controller: otpController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: Colors.grey[300],
          hintText: "OTP",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Please Enter 6 Digit Code";
          }
          return null;
        },
      ),
    );
  }
}
