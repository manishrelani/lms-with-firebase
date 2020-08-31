import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareMananer {
  static Future<String> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool loginState = prefs.get("login") ?? false;

    if (loginState) {
      String user = prefs.get("user_type");
      return user;
    }

    return "null";
  }

  static logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // AppRoutes.makeFirst(context, Login());
  }

  static void setUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
  }

  static Future<Map<String, String>> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> user = new Map<String, String>();
    user["name"] = prefs.get("name");
    user["mobile"] = prefs.get("mobile");
    user["email"] = prefs.get("email");
    user["login"] = prefs.get("login");
    user["id"] = prefs.get("id");
    user["user_type"] = prefs.get("user_type");
    user["userID"] = prefs.get("userID");
    return user;
  }

  static void setDetails(String name, String mobile, String email, String id,
      bool islogin, String userType, String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('mobile', mobile);
    await prefs.setString('email', email);
    await prefs.setString('login', islogin.toString());
    await prefs.setString('id', id);
    await prefs.setString('user_type', userType);
    await prefs.setString('userID', userID);
  }
}
