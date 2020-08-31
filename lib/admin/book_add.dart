import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms/model/book.dart';
import 'package:lms/util/firebase.dart';
import 'package:lms/widgets/book_text_form_field.dart';
import 'package:lms/util/display_alert.dart';
import 'package:lms/widgets/image_pick.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
//import 'package:path/path.dart';

class BookAdd extends StatelessWidget {
  final DocumentSnapshot data;
  BookAdd({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data == null ? 'Add a book' : 'Update book'),
      ),
      body: AddBookForm(book: data),
    );
  }
}

class AddBookForm extends StatefulWidget {
  final DocumentSnapshot book;

  AddBookForm({this.book});

  @override
  _AddBookFormState createState() => _AddBookFormState(this.book);
}

class _AddBookFormState extends State<AddBookForm> {
  final data;
  _AddBookFormState(this.data);
  final _formKey = GlobalKey<FormState>();
  File _image;
  File file;
  String type = "";
  String filename = "";
  final picker = ImagePicker();
  final databaseReference = Firestore.instance;
  var storage = FirebaseStorage.instance;
  var isLoading = false;

  var titleController = TextEditingController();
  var authorController = TextEditingController();
  var categoryController = TextEditingController();
  var descriptionController = TextEditingController();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      _image = null;
    }
    setState(() {});
  }

  @override
  void initState() {
    if (widget.book != null) {
      titleController.text = widget.book["title"];
      authorController.text = widget.book["author"];
      categoryController.text = widget.book["category"];
      descriptionController.text = widget.book["description"];
      loadProgress();
      getimageFromUrl(widget.book["image"]).then((value) {
        setState(() {
          _image = value;
        });
        print(_image.path);
      });
      getpdfFromUrl(widget.book["pdf"]).then((value) {
        loadProgress();
        setState(() {
          file = value;
          filename = file.path.split("/").last;
        });
        print(file.path);
      });

      setState(() {});
    }
    super.initState();
  }

  Future<File> getpdfFromUrl(String url) async {
    try {
      var dataUrl = await http.get(url);
      var bytes = dataUrl.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/${widget.book["title"]}.pdf");
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  Future<File> getimageFromUrl(String url) async {
    try {
      var dataUrl = await http.get(url);
      var bytes = dataUrl.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/${widget.book["title"]}.jpeg");
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(context),
        isLoading ? showProgress(context) : Container()
      ],
    );
  }

  Widget _body(context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ImagePick(
                getImage: getImage,
                image: _image,
              ),
              BookTextFormField(
                labelText: 'Title',
                controller: titleController,
                errorText: 'Enter a book title',
              ),
              BookTextFormField(
                labelText: 'Author',
                controller: authorController,
                errorText: 'Enter an author',
              ),
              BookTextFormField(
                labelText: 'Category',
                controller: categoryController,
                errorText: 'Enter a category',
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Discription",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                maxLines: 8,
                validator: (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
                    return "Enter Book's description";
                  }
                  return null;
                },
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Enter book's discription",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: file == null
                    ? FlatButton(
                        color: Colors.black26,
                        onPressed: () {
                          uploadPDF();
                        },
                        child: Text("Upload Pdf"))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Pdf File: ",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Flexible(
                            child: Text(filename),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                file = null;
                                filename = "";
                              });
                            },
                          )
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white.withOpacity(0.9),
                  child: Text(
                    widget.book == null ? 'Add Book' : 'Update Book',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    updatedata(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updatedata(context) {
    if (_formKey.currentState.validate()) {
      if (file != null && _image != null) {
        final firebase = FireBase();
        loadProgress();
        firebase.checkdata(titleController.text).then((value) async {
          if (value) {
            loadProgress();
            Fluttertoast.showToast(
              msg: "Book already exists",
              backgroundColor: Colors.black12,
            );
          } else {
            await firebase
                .setPdf(titleController.text, file)
                .then((pdfsnap) async {
              String pdf;
              if (pdfsnap.error == null) {
                pdf = await pdfsnap.ref.getDownloadURL();
                firebase
                    .getImagesnap(titleController.text, _image)
                    .then((snap) async {
                  if (snap.error == null) {
                    String url = await snap.ref.getDownloadURL();
                    Book book = Book(
                        title: titleController.text,
                        author: authorController.text,
                        category: categoryController.text,
                        description: descriptionController.text,
                        img: url,
                        pdf: pdf);

                    firebase.updateData(book).then((value) {
                      loadProgress();
                      Fluttertoast.showToast(msg: "Book Added Successfully",textColor: Colors.black);
                      Timer(Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    });
                  } else {
                    Fluttertoast.showToast(msg: "Somthing went wrong",textColor: Colors.black);
                    print("image:${snap.error}");
                  }
                });
              } else {
                Fluttertoast.showToast(msg: "Somthing went wrong",textColor: Colors.black);
                print("pdf:${pdfsnap.error}");
              }
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: "Please upload file",textColor: Colors.black);
      }
    }
  }

  uploadPDF() async {
    file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ["pdf"]);
    if (file != null) {
      setState(() {
        filename = file.path.split("/").last;
        type = filename.split(".").last;
      });

      if (type != "pdf") {
        Fluttertoast.showToast(msg: "Please Upload Pdf file only",textColor: Colors.black);
        setState(() {
          file = null;
          filename = "";
        });
      }
    }
  }

  loadProgress() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
