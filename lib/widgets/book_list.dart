import 'package:flutter/material.dart';
import 'package:lms/widgets/book_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookList extends StatelessWidget {
  final type;
  BookList({@required this.type});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("books").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: ((context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.3),
                        height: 18.0,
                      ),
                    );
                  }),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: ((context, index) {
                    return BookItem(
                      data: snapshot.data.documents[index],
                      type: type,
                    );
                  }),
                );
        });
  }
}
