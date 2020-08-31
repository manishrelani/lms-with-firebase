import 'package:flutter/material.dart';

Widget showProgress(BuildContext context) {
  return Container(
    color: Colors.black.withOpacity(0.5),
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 1,
    child: Center(child: CircularProgressIndicator()),
  );
}

 /* snackbar({String msg, bool isSucsees, BuildContext context}) {
  final snackBar = SnackBar(
    content: Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: isSucsees ? Colors.green : Colors.red,
    duration: Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
  );
  Scaffold.of(context).showSnackBar(snackBar);
}  */
