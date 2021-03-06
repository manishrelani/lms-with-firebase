import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  final String url;
  final BoxFit boxFit;
  final double height;

  BookCover({@required this.url, this.boxFit = BoxFit.fitWidth, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        /* boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ], */
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: FadeInImage.assetNetwork(
          placeholder: "assets/images/book-cover-placeholder-light.png",
          image: url,
          width: 200,
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
