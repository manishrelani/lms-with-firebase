import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lms/admin/admin_home_screen.dart';
import 'package:lms/admin/book_add.dart';
import 'package:lms/screen/pdf_view.dart';
import 'package:lms/util/ShareManager.dart';
import 'package:lms/util/firebase.dart';
import 'package:lms/util/payment.dart';
import 'package:lms/widgets/book_cover.dart';
import 'package:http/http.dart' as http;
import 'package:lms/util/display_alert.dart';
import 'package:path_provider/path_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookDetails extends StatefulWidget {
  final DocumentSnapshot data;

  BookDetails({@required this.data});

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  var isLoading = false;
  FireBase firebase = FireBase();
  Payment payment = Payment();
  String id;
  String type;
  String uid;
  @override
  void initState() {
    ShareMananer.getUserDetails().then((value) {
      setState(() {
        id = value["id"];
        type = value["user_type"];
        uid = value["userID"];
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
    return Stack(
      children: [
        Scaffold(
            appBar: _buildAppBar(context),
            body: _body(context),
            floatingActionButton: Builder(builder: (BuildContext context) {
              return Visibility(
                visible: type == "admin",
                child: FloatingActionButton(
                  child: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                ),
              );
            })),
        isLoading ? showProgress(context) : Container(),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: BookCover(
                url: widget.data["image"],
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 4.0),
              child: Text(
                '${widget.data["title"]}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'By ',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    TextSpan(
                      text: '${widget.data["author"]}',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    TextSpan(
                      text: ' in ',
                      style: Theme.of(context).textTheme.caption.copyWith(
                          fontSize: 16.0, fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: '${widget.data["category"]}',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 38.0,
            ),
            Container(
              height: 140,
              child: Text(
                '${widget.data["description"]}',
                maxLines: 7,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .caption
                        .color
                        .withOpacity(0.85),
                    fontFamily: 'Nunito',
                    fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width < 800 ? 50 : 0,
            ),
            Align(
              child: MaterialButton(
                color: Theme.of(context).primaryColor,
                child: Text("Read Book", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (id.isEmpty) {
                    memberDialogBox(context);
                  } else {
                    readPdf(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Details'),
      actions: <Widget>[
        Visibility(
          visible: type == "admin",
          child: IconButton(
            icon: Icon(
              Icons.edit,
              size: 22.0,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BookAdd(
                    data: widget.data,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  readPdf(BuildContext context) {
    loadProgress();
    getFileFromUrl(widget.data["pdf"]).then((f) {
      loadProgress();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PdfViewPage(path: f.path)));
    });
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      var dataUrl = await http.get(url);
      var bytes = dataUrl.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/${widget.data["title"]}.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      print("Error opening url file");
    }
  }

  void memberDialogBox(BuildContext context) {
    final dialog = AlertDialog(
      title: Text('Buy Menbership If you want to read this book!'),
      actions: [
        FlatButton(
          child: Text(
            'CANCEL',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(
            'BUY',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            payment.checkOption();
          },
        ),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  void _showDeleteDialog(BuildContext context) {
    final dialog = AlertDialog(
      backgroundColor: Colors.cyan,
      title: Text(
        'Delete book?',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'This will delete the book from your book list',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        FlatButton(
          child: Text(
            'CANCEL',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text(
            'ACCEPT',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
            loadProgress();
            firebase.delete(widget.data["title"]).then((value) {
              loadProgress();
              Fluttertoast.showToast(msg: "Book successfully Deleted",textColor: Colors.black);
              Timer(Duration(seconds: 1), () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => AdminHomeScreen()));
              });
            });
          },
        ),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  loadProgress() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
