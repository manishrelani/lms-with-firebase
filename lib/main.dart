import 'package:flutter/material.dart';
import 'package:lms/InitialPage.dart';


main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lms",
      home: InitialPage(),
    );
  }
}
