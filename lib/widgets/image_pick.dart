import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatelessWidget {
  final getImage;
  final File image;

  ImagePick({this.getImage, this.image});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            child: Container(
              height: 225,
              width: 175,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), 
                  child: image == null
                      ? Image.asset(
                          "assets/images/book-cover-placeholder-light.png",fit: BoxFit.fill)
                      : Image.file(image,fit: BoxFit.fill),
                )),
            onTap: () => getImage(ImageSource.gallery)),
        SizedBox(
          height: 10,
        ),
        MaterialButton(
          minWidth: 0,
          color: Colors.grey,
          child: Icon(Icons.camera_alt),
          onPressed: () => getImage(ImageSource.camera),
        ),
      ],
    );
  }
}
