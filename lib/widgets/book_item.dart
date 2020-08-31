import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/screen/book_details.dart';
import 'package:lms/widgets/book_cover.dart';

class BookItem extends StatelessWidget {
  final DocumentSnapshot data;
  final String type;
  BookItem({@required this.data, @required this.type});

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => BookDetails(
                            data: data,
                          )));
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 25.0),
              height: 200.0,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: BookCover(url: data["image"]),
                  ),
                  Flexible(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 18.0, 0.0, 18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${data["title"]}',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  'By ${data["author"]}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${data["category"]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400)),
                              Visibility(
                                visible: false,
                                child: GestureDetector(
                                  child: Icon(Icons.favorite_border),
                                  onTap: () {},
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
