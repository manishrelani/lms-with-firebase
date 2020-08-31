/*  import 'package:flutter/material.dart';
import 'package:lms/model/book.dart';
import 'package:lms/widgets/book_item.dart';

class SearchBook extends StatelessWidget {
  final List<Book> _books;

  SearchBook(this._books);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
      itemCount: _books?.length ?? bookNotifier.books.length,
      itemBuilder: ((context, index) {
        return BookItem(_books?.elementAt(index) ?? bookNotifier.books[index]);
      }),
    );
  }
} 
 */