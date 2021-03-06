import 'package:flutter/material.dart';

class Book {
  String img;
  String title;
  String description;
  String category;
  String author;
  String pdf;

  Book(
      {@required this.title,
      @required this.author,
      @required this.description,
      @required this.img,
      @required this.category,
      @required this.pdf});

  String get getPdf => pdf;

  set setPdf(String pdf) => this.pdf = pdf;

  String get getImg => img;

  set setImg(String img) => this.img = img;

  String get getTitle => title;

  set setTitle(String title) => this.title = title;

  String get getDescription => description;

  set setDescription(String description) => this.description = description;

  String get getCategory => category;

  set setCategory(String category) => this.category = category;

  String get getAuthor => author;

  set setAuthor(String author) => this.author = author;

  data() {
    Map<String, String> data = Map();
    data["title"] = title;
    data["author"] = author;
    data["category"] = category;
    data["image"] = img;
    data["description"] = description;
    data["pdf"]=pdf;
    return data;
  }
}

/* final initialBooks = [
  Book(
    'The Doe in the Forest',
    'Laurel Toven',
    'In this book, we have a geographical historical and cultural region in the wester, part of the country of Belgium',
    'https://about.canva.com/wp-content/uploads/sites/3/2015/01/children_bookcover.png',
    'Children',
  ),
  Book(
    'Norse Mythology',
    'Neil Gaiman',
    'The immortal #1 New York Times bestseller',
    'https://pro2-bar-s3-cdn-cf3.myportfolio.com/560d16623f9c2df9615744dfab551b3d/e50c016f-b6a8-4666-8fb8-fe6bd5fd9fec_rw_1920.jpeg?h=dc627898fc5eac88aa791fb2b124ecbd',
    'Religion',
  ),
  Book(
    'The Sun, the Moon, the Stars',
    'Junot Diaz',
    'Winner of the Pulitzer Prize',
    'https://pro2-bar-s3-cdn-cf4.myportfolio.com/2e52194b029a65d876d57172b412d63e/5a0ce3f3-5f59-4098-8d45-93a73cf2800c_rw_1200.png?h=40a11543bd7bdc2d8e956150e3a5af2c',
    'Drama',
  ),
]; */
