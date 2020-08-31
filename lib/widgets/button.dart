import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function signup;
  MyButton( this.signup);
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey,
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
              signup(context);
          }),
    );
  }
}
