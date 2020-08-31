import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/admin/adminLoginScreen.dart';
import 'package:lms/admin/admin_home_screen.dart';
import 'package:lms/screen/LoginPage.dart';
import 'package:lms/screen/OtpPage.dart';
import 'package:lms/screen/email_verification.dart';
import 'package:lms/util/ShareManager.dart';
import 'package:lms/util/firebase.dart';
import 'package:local_auth/local_auth.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';

  bool authenticated = false;

  Future checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      canCheckBiometrics = canCheckBiometrics;
      print(canCheckBiometrics);
    });
    return canCheckBiometrics;
  }

  Future<void> authenticate() async {
    authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          // sensitiveTransaction: false,
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      print(_authorized);
    });
  }

  @override
  void initState() {
    FireBase fireBase = FireBase();
    fireBase.getCurrentUser().then((user) {
      if (user != null) {
        print("initialPage user:${user.uid}");
        checkBiometrics().then((value) {
          if (value) {
            authenticate().then((value) {
              if (!authenticated) {
                SystemNavigator.pop();
              } else if (authenticated) {
                if (user.uid == "eEK6KzeefFR4CIZ9HVrHlsdDyUl1")
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => AdminHomeScreen()));
                else {
                  fireBase.isEmailVerified().then((value) {
                    if (value)
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => AdminHomeScreen()));
                    else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (ctx) => EmailVerification()));
                    }
                  });
                }
              }
            });
          } else {
            print("No fingerprint available");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) => AdminHomeScreen()));
          }
        });
      } else
        print("No user");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          container(
              name: "Admin",
              image: "assets/images/admin.png",
              route: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => AdminLogin()));
              }),
          container(
              name: "User",
              image: "assets/images/user.png",
              route: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => LoginPage()));
              }),
        ],
      ),
    );
  }

  Widget container({String name, image, Function route}) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 130,
              fit: BoxFit.fill,
            ),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        ),
      ),
      onTap: route,
    );
  }
}
