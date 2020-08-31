import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/InitialPage.dart';
import 'package:lms/admin/book_add.dart';
import 'package:lms/screen/clgUserId.dart';
import 'package:lms/util/ShareManager.dart';
import 'package:lms/util/firebase.dart';
import 'package:lms/util/payment.dart';
import 'package:lms/widgets/book_list.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  FireBase firebase = FireBase();
  Payment payment = Payment();

  String uid;
  String userType;
  String name;
  String email;
  String id;
  Map data;
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    "Book library",
    style: new TextStyle(color: Colors.white),
  );

  @override
  void initState() {
    ShareMananer.getUserDetails().then((value) {
      setState(() {
        data = value;
        uid = value["userID"];
        userType = value["user_type"];
        name = value["name"];
        email = value["email"];
        id = value["id"];
        print(uid);
        payment.event(_handlePaymentSuccess, _handlePaymentError);
      });
    });

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment successfull",
        textColor: Colors.white,
        backgroundColor: Colors.green);
    print("sucssess");
    firebase.updateUser(uid).then((value) {
      ShareMananer.setUserId(uid);
      setState(() {
        id = uid;
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Faield",
        textColor: Colors.white,
        backgroundColor: Colors.red);
    print("failed");
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: _buildAppBar(context),
            drawer: _drawer(),
            body: Container(
              child: BookList(type: userType),
            ),
            floatingActionButton: Visibility(
              visible: userType == "admin",
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => BookAdd()));
                },
              ),
            ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Book Library'),
      actions: [
      /*   IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // showSearch(context: context, delegate: BookSearch());
          },
        ), */
      ],
    );
  }

  Drawer _drawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            height: 100,
            child: UserAccountsDrawerHeader(
              accountEmail: Text(email),
              accountName: Text(name),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Visibility(
            visible: userType == "admin",
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("College member list"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => ClgUserID()));
              },
            ),
          ),
          Visibility(
            visible: false,
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favorites Books"),
            ),
          ),
          Visibility(
              visible: id.isEmpty,
              child: Builder(
                builder: (context) {
                  return ListTile(
                    leading: Icon(Icons.card_membership),
                    title: Text("Buy Membership"), 
                    onTap: () {
                      payment.checkOption();
                    },
                  );
                },
              )),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text("Logout"),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed: () {
        firebase.signOut().then((value) {
          ShareMananer.logOut(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => InitialPage()),
              (route) => false);
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

/* GestureDetector(
            child: Icon(Icons.power_settings_new),
            onTap: () {
              fireBase.signOut().then((value) => {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (ctx) => InitialPage()),
                        (route) => false)
                  });
            },
          ), */
